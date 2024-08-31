import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../../user/userController/usercontroller.dart';
import '../../user/userController/userprofilecontroller.dart';
import '../controller/bookingcontroller.dart';
import '../controller/main_screen_controller.dart';
import '../models/bookingmodal.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  BookingCard({required this.booking});
  final BookingController controller = Get.put(BookingController());
  final controll = Get.find<UserProfileGetUser>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _priceController = TextEditingController(
      text: controller.currentPrice.toString(),
    );
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Request",
              style: TextStyle(color: Colors.green, fontSize: 14),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                      'images/origin.png'), // Replace with actual image
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.name ?? 'User',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        height: 30,
                        width: 200,
                        child: AutoSizeText(
                          booking.toLocationAddress,
                          maxLines: 3,
                        )), // Example rating
                    Text(booking.vehicle), // Example car model
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("6 min."),
                    Text("380 m"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "PKR ${booking.price.toStringAsFixed(0)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) =>
                      _buildBottomSheet(context, _priceController),
                );
              },
              title: Obx(
                () => Text(
                  controller.currentPrice.value.toString(),
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              trailing: Icon(Icons.edit),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.declineBooking(
                          Get.find<UserProfileGetUser>().userModel.value.id!);
                    },
                    child: Text(
                      "Decline",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300]),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.acceptBooking(booking);
                      Get.to(MapScreenRider(
                        userbooking: booking,
                      ));
                      print(booking.price);
                    },
                    child: Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(
      BuildContext context, TextEditingController _priceController) {
    final controller = Get.put(BookingController());

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Offer your fare',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                prefixText: 'PKR ',
                border: UnderlineInputBorder(borderSide: BorderSide.none)),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Recommended fare PKR 656',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text('Promo code'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Add promo code functionality
            },
          ),
          ListTile(
            title: Text('Cash'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Add payment option functionality
            },
          ),
          Obx(() {
            return SwitchListTile(
              value: false,
              onChanged: (bool value) {
                // Handle the switch
              },
              title: Text(
                  'Automatically accept the nearest driver for PKR ${controller.currentPrice}'),
            );
          }),
          SizedBox(height: 20),
          SizedBox(
            width: 330,
            child: ElevatedButton(
              onPressed: () {
                controller.updatePrice(int.parse(_priceController.text));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text('Done',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class MapScreenRider extends StatefulWidget {
  final Booking userbooking;
  const MapScreenRider({super.key, required this.userbooking});

  @override
  State<MapScreenRider> createState() => _MapScreenRiderState();
}

class _MapScreenRiderState extends State<MapScreenRider> {
  static const maxSeconds = 120; // 2 minutes
  int remainingSeconds = maxSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer when the widget is initialized
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer?.cancel();
        }
      });
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenController());

    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 19, color: Colors.black),
          ),
        ),
      ]),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(31.4505, 74.3532), // Set the camera to the midpoint
              zoom: 14.0, // Adjust the zoom level as necessary
            ),
            onMapCreated: (GoogleMapController mapController) {},
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 150),
            child: Text(
              formatTime(remainingSeconds),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: Get.height * 0.7,
            left: 20,
            child: Container(
              height: 150,
              width: Get.width * .9,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  ListTile(
                    leading: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(Iconsax.user),
                        ),
                        Text(
                          widget.userbooking.name ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    title: SizedBox(
                      width: 100,
                      height: 20,
                      child: AutoSizeText(
                        widget.userbooking.toLocationAddress ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 3,
                      ),
                    ),
                    subtitle: Text(
                      'PKR${widget.userbooking.price ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Iconsax.call,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: Get.width * 0.8,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            Get.back();
                          },
                          child: Center(
                              child: Text(
                            'I have Arrived',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ))))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
