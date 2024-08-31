import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liferfoodrider/user/userController/userprofilecontroller.dart';
import 'package:vibration/vibration.dart';

import '../../user/Assistants/assistant_methods.dart';
import '../../user/Assistants/black_theme_google_map.dart';
import '../../user/global/global.dart';
import '../controller/bookingcontroller.dart';
import '../pushNotification/push_notification_system.dart';
import '../screens/new_trip_screen.dart';
import '../widgets/bookingcard.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final control = Get.find<UserProfileGetUser>();
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String? statusText;
  Color? buttonColor;
  bool? isDriverActive;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            driverCurrentPosition!, context);
    print("This is our address = $humanReadableAddress");

    AssistantMethods.readDriverRatings(context);
  }

  readCurrentDriverInformation() async {
    currentUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.address = (snap.snapshot.value as Map)["address"];
        onlineDriverData.ratings = (snap.snapshot.value as Map)["ratings"];
        onlineDriverData.car_model =
            (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number =
            (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_color =
            (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_type =
            (snap.snapshot.value as Map)["car_details"]["type"];

        driverVehicleType = (snap.snapshot.value as Map)["car_details"]["type"];
      }
    });

    AssistantMethods.readDriverEarnings(context);
  }

  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(31.4505, 74.3532),
            zoom: 14.0,
          ),
          markers: Set<Marker>.of(controller.markers), // Observe markers
          polylines: Set<Polyline>.of(controller.polylines),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 600, // Adjust the height to fit your cards
              child: StreamBuilder(
                stream: controller.getBookingsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching bookings"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(""));
                  } else {
                    // Vibrate on new data
                    if (snapshot.hasData) {
                      Vibration.vibrate(duration: 500);
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return BookingCard(booking: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),

        statusText != "online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.4),
              )
            : Container(),

        //button for online/offine driver
        Positioned(
          top: statusText != "online"
              ? MediaQuery.of(context).size.height * 0.45
              : 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (isDriverActive != true) {
                        driverIsOnlineNow();
                        updateDriversLocationAtRealTime();

                        setState(() {
                          statusText = "online";
                          isDriverActive = true;
                          buttonColor = Colors.green;
                        });
                      } else {
                        driverIsOfflineNow();
                        setState(() {
                          statusText = "offline";
                          isDriverActive = false;
                          buttonColor = Colors.red;
                        });
                        Fluttertoast.showToast(msg: "You are offline now");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        )),
                    child: statusText != "online"
                        ? Text(
                            statusText ?? "Offline",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        : const Icon(
                            Icons.phonelink_ring,
                            color: Colors.white,
                            size: 26,
                          ),
                  ),

                  // SizedBox(width: 10,),
                  //
                  // ElevatedButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       primary: buttonColor,
                  //       padding: EdgeInsets.symmetric(horizontal: 18),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(26),
                  //       )
                  //   ),
                  //   child: Text(
                  //     "\$ ${control.driverModel.value.balance}",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //   )
                  // ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude)
        .then((_) {
      print("Driver location saved successfully.");
    }).catchError((error) {
      print("Error saving driver location: $error");
    });

    // //CarType
    // DatabaseReference carTypeRef = FirebaseDatabase.instance.ref().child("activeDrivers").child(currentUser!.uid).child("type");
    // carTypeRef.set(carModelCurrentInfo!.type).then((_) {
    //   print("Car type data saved successfully.");
    // }).catchError((error) {
    //   print("Error saving car type data: $error");
    // });

    //NewRideStatus
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) {});

    //Status
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("status")
        .set("online");
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      if (isDriverActive == true) {
        Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
          driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("status")
        .set("offline");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    // });
  }
}
