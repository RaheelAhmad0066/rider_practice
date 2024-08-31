import 'package:firebase_database/firebase_database.dart';
import 'package:liferfoodrider/driver/models/bookingmodal.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../user/global/global.dart';
import '../../user/userController/userprofilecontroller.dart';
import '../widgets/bookingcard.dart';

class BookingController extends GetxController {
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getBookingsStream();
    super.onInit();
  }

  // Firebase reference
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref("UserBookingDetail");

  Stream<List> getBookingsStream() {
    return databaseRef.onValue.map((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> bookingsMap =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        return bookingsMap.entries.map((entry) {
          String bookingId = entry.key;
          Map<String, dynamic> bookingData =
              Map<String, dynamic>.from(entry.value);
          return Booking.fromJson(bookingId, bookingData);
        }).toList();
      } else {
        print("No data available");
        return [];
      }
    }).handleError((e) {
      print("Error fetching data: $e");
      return [];
    });
  }

  void declineBooking(String bookingId) {
    databaseRef.child(bookingId).remove().then((_) {
      Get.snackbar(
        "Booking Declined",
        "The booking request has been declined.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }).catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to decline the booking: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  var currentPrice = 0.obs;

  // Method to update the current fare price
  void updatePrice(int newPrice) {
    currentPrice.value = newPrice;
  }

  // Method to accept booking
  void acceptBooking(Booking booking) {
    // Add markers and polyline
    addMarker(booking.fromLocationLatitude, booking.fromLocationLongitude,
        'From Location');
    addMarker(
        booking.toLocationLatitude, booking.toLocationLongitude, 'To Location');
    addPolyline([
      LatLng(booking.fromLocationLatitude, booking.fromLocationLongitude),
      LatLng(booking.toLocationLatitude, booking.toLocationLongitude)
    ]);

    // Post accepted booking details to Firebase
    postAcceptedBooking(booking.bookingId, booking);
  }

  // Add marker to the map
  void addMarker(double latitude, double longitude, String markerId) {
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: markerId),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(marker);
  }

  // Add polyline to the map
  void addPolyline(List<LatLng> polylinePoints) {
    Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.red,
      width: 5,
      points: polylinePoints,
    );

    polylines.add(polyline);
  }

  final controller = Get.find<UserProfileGetUser>();
  // Post accepted booking details to Firebase
  void postAcceptedBooking(String bookingId, Booking booking) {
    final acceptedBookingRef =
        FirebaseDatabase.instance.ref("AcceptedBookings").child(bookingId);

    num priceToPost =
        currentPrice.value != 0 ? currentPrice.value : booking.price;

    acceptedBookingRef.set({
      'name': controller.driverModel.value.name ?? '',
      'vehicle': controller.driverModel.value.type ?? '',
      'price': priceToPost,
      'phone': controller.driverModel.value.phone ?? '',
      'carcolour': controller.driverModel.value.carDetails!.carColor ?? '',
      'carmodal': controller.driverModel.value.carDetails!.carModel ?? '',
      'typecar': controller.driverModel.value.carDetails!.type ?? '',
    }).then((_) {
      Get.snackbar(
        "Booking Accepted",
        "Booking details have been posted successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
      declineBooking(booking.bookingId);
      Get.to(MapScreenRider());
    }).catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to post booking details: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
}
