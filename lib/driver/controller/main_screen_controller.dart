import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/places.dart' as places;
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../../user/userController/usercontroller.dart';
import '../models/main_controller.dart';

class MainScreenController extends GetxController {
  var fromLocation = Rx<LatLng?>(null);
  var toLocation = Rx<LatLng?>(null);
  var toLocationAddress = Rx<String>('');
  var fromLocationAddress = Rx<String>('');
  var currentLocation = Rx<loc.LocationData?>(null);
  var distanceInMeters = 0.0.obs;
  var timeToReach = 0.0.obs;
  var polyLineCoordinates = <LatLng>[].obs;

  final loc.Location location = loc.Location();
  final places.GoogleMapsPlaces placesAPI = places.GoogleMapsPlaces(
    apiKey:
        'AIzaSyCa-bvn_Yn-y9qBLglmPPSQ4HJRecxgd8k', // Replace with your actual API key
  );

  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();

    initializeLocation();
  }

  @override
  void onClose() {
    _locationSubscription?.cancel();
    super.onClose();
  }

  var currentPrice = 0.obs;

  // Method to update the current fare price
  void updatePrice(int newPrice) {
    currentPrice.value = newPrice;
  }

  var selectedVehicle = ''.obs;

  void selectVehicle(String vehicle) {
    selectedVehicle.value = vehicle;
  }

  Future<void> initializeLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print('Location services are disabled.');
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          print('Location permission denied.');
          return;
        }
      }

      getCurrentLocation();
    } catch (e) {
      print('Error initializing location: $e');
    }
  }

  void getCurrentLocation() async {
    try {
      loc.LocationData? locationData = await location.getLocation();
      if (locationData != null) {
        currentLocation.value = locationData;
        _getPolylinePoints();

        _locationSubscription = location.onLocationChanged.listen((newLoc) {
          if (newLoc != null) {
            currentLocation.value = newLoc;
            updateDistanceAndTime();
          }
        });
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void selectFromLocation(String placeId) async {
    try {
      places.PlacesDetailsResponse detail =
          await placesAPI.getDetailsByPlaceId(placeId);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      fromLocation.value = LatLng(lat, lng);
      fromLocationAddress.value =
          detail.result.formattedAddress ?? 'Unknown location';
      _getPolylinePoints();
      adjustCameraToBounds(); // Adjust camera to show both locations
    } catch (e) {
      print('Error selecting from location: $e');
    }
  }

  GoogleMapController? mapController;
  void selectToLocation(String placeId) async {
    try {
      places.PlacesDetailsResponse detail =
          await placesAPI.getDetailsByPlaceId(placeId);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      toLocation.value = LatLng(lat, lng);
      toLocationAddress.value =
          detail.result.formattedAddress ?? 'Unknown location';
      _getPolylinePoints();
      adjustCameraToBounds(); // Adjust camera to show both locations
    } catch (e) {
      print('Error selecting to location: $e');
    }
  }

  void adjustCameraToBounds() {
    if (fromLocation.value != null && toLocation.value != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          fromLocation.value!.latitude < toLocation.value!.latitude
              ? fromLocation.value!.latitude
              : toLocation.value!.latitude,
          fromLocation.value!.longitude < toLocation.value!.longitude
              ? fromLocation.value!.longitude
              : toLocation.value!.longitude,
        ),
        northeast: LatLng(
          fromLocation.value!.latitude > toLocation.value!.latitude
              ? fromLocation.value!.latitude
              : toLocation.value!.latitude,
          fromLocation.value!.longitude > toLocation.value!.longitude
              ? fromLocation.value!.longitude
              : toLocation.value!.longitude,
        ),
      );

      // Animate the camera to fit both locations within the bounds
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  var bookings = <UserBook>[].obs;
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref().child('AcceptedBookings');

  void fetchBookings() {
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        String bookingId = event.snapshot.key!;
        Map<String, dynamic> bookingData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        bookings.add(UserBook.fromJson(bookingId, bookingData));

        // Trigger vibration when a new booking is added
        if (Vibration.hasVibrator() != null) {
          Vibration.vibrate();
        }
      }
    });

    databaseRef.onChildChanged.listen((event) {
      if (event.snapshot.exists) {
        String bookingId = event.snapshot.key!;
        Map<String, dynamic> updatedData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        int index = bookings.indexWhere((booking) => booking.id == bookingId);
        if (index != -1) {
          bookings[index] = UserBook.fromJson(bookingId, updatedData);
        }
      }
    });

    databaseRef.onChildRemoved.listen((event) {
      String bookingId = event.snapshot.key!;
      bookings.removeWhere((booking) => booking.id == bookingId);
    });
  }

  void deleteBooking(String id) async {
    await databaseRef.child(id).remove();
    fetchBookings(); // Refresh the list
  }

  void _getPolylinePoints() async {
    if (fromLocation.value == null || toLocation.value == null) return;

    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: 'AIzaSyCa-bvn_Yn-y9qBLglmPPSQ4HJRecxgd8k',
        request: PolylineRequest(
          origin: PointLatLng(
              fromLocation.value!.latitude, fromLocation.value!.longitude),
          destination: PointLatLng(
              toLocation.value!.latitude, toLocation.value!.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        polyLineCoordinates.clear();
        result.points.forEach((PointLatLng point) {
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        print('Polyline Coordinates: $polyLineCoordinates'); // Debugging line
      } else {
        print('Unable to get route: ${result.errorMessage}');
      }

      updateDistanceAndTime();
      getPolylines();
      update(); // Ensure UI updates after changes
    } catch (e) {
      print('Error getting polyline points: $e');
    }
  }

  void updateDistanceAndTime() {
    if (fromLocation.value != null && toLocation.value != null) {
      distanceInMeters.value = Geolocator.distanceBetween(
        fromLocation.value!.latitude,
        fromLocation.value!.longitude,
        toLocation.value!.latitude,
        toLocation.value!.longitude,
      );

      double averageSpeed = 13.89; // m/s (50 km/h)
      timeToReach.value = distanceInMeters.value / averageSpeed;
    }
  }

  Future<Set<Marker>> getMarkers() async {
    Set<Marker> markers = {};

    // Load custom marker images
    BitmapDescriptor fromLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
          size: Size(48, 48)), // You can adjust the size if needed
      'images/origin.png', // Replace with your actual image path
    );

    BitmapDescriptor toLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
          size: Size(20, 20)), // You can adjust the size if needed
      'images/destination.png', // Replace with your actual image path
    );

    if (fromLocation.value != null) {
      markers.add(Marker(
        markerId: MarkerId('fromLocation'),
        position: fromLocation.value!,
        infoWindow: InfoWindow(title: 'From: ${fromLocationAddress.value}'),
        icon: fromLocationIcon,
      ));
    }

    if (toLocation.value != null) {
      markers.add(Marker(
        markerId: MarkerId('toLocation'),
        position: toLocation.value!,
        infoWindow: InfoWindow(title: 'To: ${toLocationAddress.value}'),
        icon: toLocationIcon,
      ));
    }

    return markers;
  }

  Set<Polyline> getPolylines() {
    Set<Polyline> polylines = {};

    if (polyLineCoordinates.isNotEmpty) {
      polylines.add(Polyline(
        polylineId: PolylineId('route'),
        color: Colors.red,
        points: polyLineCoordinates,
        width: 2,
      ));
    }

    return polylines;
  }

  var isLoading = false.obs;
  Future<void> postData(UserDB locationData) async {
    final DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('UserBookingDetail');
    isLoading.value = true;
    try {
      await dbRef.push().set(locationData.toJson());
      print("Data posted successfully!");
    } catch (e) {
      print("Failed to post data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
