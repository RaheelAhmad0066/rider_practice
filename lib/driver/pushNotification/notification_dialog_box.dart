import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liferfoodrider/driver/models/user_ride_request_information.dart';
import 'package:liferfoodrider/driver/screens/new_trip_screen.dart';

import '../../user/global/global.dart';
import '../../user/splashScreen/splash_screen.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: darkTheme ? Colors.black : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              onlineDriverData.car_type == "Car"
                  ? "images/Car.png"
                  : onlineDriverData.car_type == "CNG"
                      ? "images/CNG.png"
                      : "images/Bike.png",
            ),

            const SizedBox(
              height: 10,
            ),

            //title
            Text(
              "New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Divider(
              height: 2,
              thickness: 2,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme
                                  ? Colors.amber.shade400
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme
                                  ? Colors.amber.shade400
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            Divider(
              height: 2,
              thickness: 2,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),

            //buttons for cancelling and accepting the ride request
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        audioPlayer.pause();
                        audioPlayer.stop();
                        audioPlayer = AssetsAudioPlayer();

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        audioPlayer.pause();
                        audioPlayer.stop();
                        audioPlayer = AssetsAudioPlayer();

                        acceptRideRequest(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        "Accept".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) async {
      if (snap.snapshot.value == "idle") {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(firebaseAuth.currentUser!.uid)
            .child("newRideStatus")
            .set("accepted");

        //RideRequestID
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentUser!.uid)
            .child("rid")
            .set(widget.userRideRequestDetails!.rideRequestId);

        //RideRequestStatus
        await FirebaseDatabase.instance
            .ref()
            .child("All Ride Requests")
            .child(widget.userRideRequestDetails!.rideRequestId!)
            .child("status")
            .set("status");

        //RideRequestStatus
        DatabaseReference rideRequestRef = FirebaseDatabase.instance
            .ref()
            .child("All Ride Requests")
            .child(widget.userRideRequestDetails!.rideRequestId!);

        //Saving ride request id to users
        rideRequestRef.once().then((snap) async {
          var userId = (snap.snapshot.value as dynamic)["userId"];
          await FirebaseDatabase.instance
              .ref()
              .child("users")
              .child(userId)
              .child("rid")
              .set(widget.userRideRequestDetails!.rideRequestId!);
          await FirebaseDatabase.instance
              .ref()
              .child("users")
              .child(userId)
              .child("rVehicleType")
              .set(carModelCurrentInfo!.type);
        });

        //await AssistantMethods.pauseLiveLocationUpdates();

        Fluttertoast.showToast(msg: "Ride accepted. Please wait");

        //trip started now - send driver to new tripScreen
        Timer(const Duration(seconds: 5), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => NewTripScreen()));
        });
      } else {
        Fluttertoast.showToast(msg: "This Ride Request do not exists.");
        Future.delayed(const Duration(milliseconds: 4000), () {
          //Status
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(currentUser!.uid)
              .child("status")
              .set("offline");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const SplashScreen()));
        });
      }
    });
  }
}
