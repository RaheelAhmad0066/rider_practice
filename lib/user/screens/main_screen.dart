import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liferfoodrider/driver/models/main_controller.dart';
import 'package:liferfoodrider/user/screens/search_places_screen.dart';
import 'package:liferfoodrider/user/userController/usercontroller.dart';
import '../../driver/controller/main_screen_controller.dart';
import '../../driver/screens/drawer_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:vibration/vibration.dart';
import '../global/global.dart';
import '../userController/userprofilecontroller.dart';
import 'drawer_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    final userprofile = Get.find<UserProfileGetUser>();
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
    final controller = Get.put(MainScreenController());
    TextEditingController _priceController = TextEditingController(
      text: controller.currentPrice.toString(),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        drawer: User_Drawer(),
        body: Stack(
          children: [
            FutureBuilder<Set<Marker>>(
              future: controller.getMarkers(), // Load markers asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Show a loader while markers are loading
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Error loading markers")); // Handle errors
                } else if (snapshot.hasData) {
                  LatLng fromLocation = controller.fromLocation.value ??
                      LatLng(31.4505, 74.3532); // Default location if null
                  LatLng toLocation = controller.toLocation.value ??
                      LatLng(31.4505, 74.3532); // Default location if null
                  LatLng midPoint = LatLng(
                    (fromLocation.latitude + toLocation.latitude) / 2,
                    (fromLocation.longitude + toLocation.longitude) / 2,
                  );

                  return GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: midPoint, // Set the camera to the midpoint
                      zoom: 14.0, // Adjust the zoom level as necessary
                    ),

                    markers: snapshot.data!, // Use the loaded markers
                    polylines: controller.getPolylines(),
                    onMapCreated: (GoogleMapController mapController) {
                      // Optionally adjust the camera bounds to fit the polyline
                      LatLngBounds bounds = LatLngBounds(
                        southwest: LatLng(
                          fromLocation.latitude < toLocation.latitude
                              ? fromLocation.latitude
                              : toLocation.latitude,
                          fromLocation.longitude < toLocation.longitude
                              ? fromLocation.longitude
                              : toLocation.longitude,
                        ),
                        northeast: LatLng(
                          fromLocation.latitude > toLocation.latitude
                              ? fromLocation.latitude
                              : toLocation.latitude,
                          fromLocation.longitude > toLocation.longitude
                              ? fromLocation.longitude
                              : toLocation.longitude,
                        ),
                      );
                      mapController.animateCamera(
                          CameraUpdate.newLatLngBounds(bounds, 50));
                    },
                  );
                } else {
                  return Center(child: Text("No markers available"));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Obx(
                () => Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 300, // Adjust the height to fit your cards
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.bookings.length,
                      itemBuilder: (context, index) {
                        final booking = controller.bookings[index];
                        return UserBookingCard(booking: booking);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  _scaffoldState.currentState!.openDrawer();
                },
                child: CircleAvatar(
                  backgroundColor:
                      darkTheme ? Colors.amber.shade400 : Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: darkTheme ? Colors.black : Colors.lightBlue,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: darkTheme ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectVehicle('Bike');
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller
                                                      .selectedVehicle.value ==
                                                  'Bike'
                                              ? Colors.lightBlueAccent
                                              : Colors.grey.shade300,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Image.asset('images/Bike.png',
                                            width: 30, height: 30),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('Bike'),
                                    ],
                                  ),
                                );
                              }),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectVehicle('Car');
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller
                                                      .selectedVehicle.value ==
                                                  'Car'
                                              ? Colors.lightBlueAccent
                                              : Colors.grey.shade300,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Image.asset('images/Car.png',
                                            width: 30, height: 30),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('Car'),
                                    ],
                                  ),
                                );
                              }),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectVehicle('Bus');
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller
                                                      .selectedVehicle.value ==
                                                  'Bus'
                                              ? Colors.lightBlueAccent
                                              : Colors.grey.shade300,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Image.asset('images/bus.png',
                                            width: 30, height: 30),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('Bus'),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: darkTheme
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.blue,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "From",
                                            style: TextStyle(
                                              color: darkTheme
                                                  ? Colors.amber.shade400
                                                  : Colors.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              // Open search place screen
                                              var placeId = await Get.to(
                                                  () => SearchPlacesScreen(
                                                        isSelectingFromLocation:
                                                            true,
                                                      ));
                                              if (placeId != null) {
                                                controller.selectFromLocation(
                                                    placeId);
                                              }
                                            },
                                            child: Obx(() {
                                              return SizedBox(
                                                width: Get.width * 0.5,
                                                height: 20,
                                                child: AutoSizeText(
                                                  controller.fromLocationAddress
                                                          .value.isNotEmpty
                                                      ? controller
                                                          .fromLocationAddress
                                                          .value
                                                      : "Choose pick-up point",
                                                  style: TextStyle(
                                                    color: darkTheme
                                                        ? Colors.grey
                                                        : Colors.black54,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Divider(
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.blue,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To",
                                            style: TextStyle(
                                              color: darkTheme
                                                  ? Colors.amber.shade400
                                                  : Colors.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              // Open search place screen
                                              var placeId = await Get.to(
                                                  () => SearchPlacesScreen(
                                                        isSelectingFromLocation:
                                                            false,
                                                      ));
                                              if (placeId != null) {
                                                controller
                                                    .selectToLocation(placeId);
                                              }
                                            },
                                            child: Obx(() {
                                              return SizedBox(
                                                height: 20,
                                                width: Get.width * 0.5,
                                                child: AutoSizeText(
                                                  controller.toLocationAddress
                                                          .value.isNotEmpty
                                                      ? controller
                                                          .toLocationAddress
                                                          .value
                                                      : 'Choose pick-up point',
                                                  style: TextStyle(
                                                    color: darkTheme
                                                        ? Colors.grey
                                                        : Colors.black54,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => _buildBottomSheet(
                                    context, _priceController),
                              );
                            },
                            title: Obx(
                              () => Text(
                                'PKR${controller.currentPrice.value.toString()}',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: Icon(Icons.edit),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 34,
                            width: 330,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue.withOpacity(0.2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                ),
                                Obx(() => Text(
                                    'Travel time - ${controller.timeToReach.value} min'))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 330,
                            height: 50,
                            child: Obx(
                              () => controller.isLoading.value
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: () {
                                        UserDB userDetail = UserDB(
                                          id: userprofile.userModel.value.id ??
                                              '',
                                          vehicale:
                                              controller.selectedVehicle.value,
                                          name: userprofile
                                                  .userModel.value.name ??
                                              '',
                                          toLocationlatitude: controller
                                              .toLocation.value!.latitude,
                                          toLocationlongitude: controller
                                              .toLocation.value!.longitude,
                                          fromlatitude: controller
                                              .fromLocation.value!.latitude,
                                          fromlongitude: controller
                                              .fromLocation.value!.longitude,
                                          fromLocationAddress: controller
                                              .fromLocationAddress.value,
                                          toLocationAddress: controller
                                              .toLocationAddress.value,
                                          price: controller.currentPrice.value,
                                        );

                                        controller
                                            .postData(userDetail)
                                            .then((va) {
                                          return showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return Container(
                                                  height:
                                                      200, // Set the height of the container
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Obx(
                                                              () => Text(
                                                                '${controller.bookings.length} drivers are viewing your offer',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Obx(() => Row(
                                                              children: [
                                                                Badge(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  smallSize: 10,
                                                                  largeSize: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                  width:
                                                                      Get.width *
                                                                          0.8,
                                                                  child:
                                                                      AutoSizeText(
                                                                    'to ${controller.toLocationAddress.value}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                    maxLines: 3,
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        Obx(() => Row(
                                                              children: [
                                                                Badge(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  smallSize: 10,
                                                                  largeSize: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                  width:
                                                                      Get.width *
                                                                          0.8,
                                                                  child:
                                                                      AutoSizeText(
                                                                    'from ${controller.fromLocationAddress.value}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                    maxLines: 3,
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        SizedBox(
                                                          width: Get.width,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'Cancel Request',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.blue, // Button color
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12))),
                                      child: Text('Find Driver',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(
      BuildContext context, TextEditingController _priceController) {
    final controller = Get.put(MainScreenController());

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

class UserBookingCard extends StatefulWidget {
  final UserBook booking;

  UserBookingCard({required this.booking});

  @override
  State<UserBookingCard> createState() => _UserBookingCardState();
}

class _UserBookingCardState extends State<UserBookingCard> {
  late final _timer;

  int _progress = 10;

  final controller = Get.put(MainScreenController());

  @override
  void initState() {
    super.initState();

    // Vibrate when the card is created
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_progress > 0) {
          _progress--;
        } else {
          timer.cancel();
          controller.deleteBooking(widget.booking.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your fare",
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
                      widget.booking.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("4.9 (3659 rides)"), // Example rating
                    Text(widget.booking.typecar), // Example car model
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
              'PKR ${widget.booking.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.deleteBooking(widget.booking.id);
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
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(MapScreenUser(
                        userbooking: widget.booking,
                      ));
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
            LinearProgressIndicator(
              value: _progress / 10,
              color: Colors.blue,
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreenUser extends StatefulWidget {
  final UserBook? userbooking;
  const MapScreenUser({super.key, this.userbooking});

  @override
  State<MapScreenUser> createState() => _MapScreenUserState();
}

class _MapScreenUserState extends State<MapScreenUser> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenController());
    final contro = Get.find<UserProfileGetUser>();

    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Cancle',
            style: TextStyle(fontSize: 19, color: Colors.black),
          ),
        ),
      ]),
      body: Stack(
        children: [
          FutureBuilder<Set<Marker>>(
            future: controller.getMarkers(), // Load markers asynchronously
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Show a loader while markers are loading
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("Error loading markers")); // Handle errors
              } else if (snapshot.hasData) {
                LatLng fromLocation = controller.fromLocation.value ??
                    LatLng(31.4505, 74.3532); // Default location if null
                LatLng toLocation = controller.toLocation.value ??
                    LatLng(31.4505, 74.3532); // Default location if null
                LatLng midPoint = LatLng(
                  (fromLocation.latitude + toLocation.latitude) / 2,
                  (fromLocation.longitude + toLocation.longitude) / 2,
                );

                return GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: midPoint, // Set the camera to the midpoint
                    zoom: 14.0, // Adjust the zoom level as necessary
                  ),

                  markers: snapshot.data!, // Use the loaded markers
                  polylines: controller.getPolylines(),
                  onMapCreated: (GoogleMapController mapController) {
                    // Optionally adjust the camera bounds to fit the polyline
                    LatLngBounds bounds = LatLngBounds(
                      southwest: LatLng(
                        fromLocation.latitude < toLocation.latitude
                            ? fromLocation.latitude
                            : toLocation.latitude,
                        fromLocation.longitude < toLocation.longitude
                            ? fromLocation.longitude
                            : toLocation.longitude,
                      ),
                      northeast: LatLng(
                        fromLocation.latitude > toLocation.latitude
                            ? fromLocation.latitude
                            : toLocation.latitude,
                        fromLocation.longitude > toLocation.longitude
                            ? fromLocation.longitude
                            : toLocation.longitude,
                      ),
                    );
                    mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(bounds, 50));
                  },
                );
              } else {
                return Center(child: Text("No markers available"));
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              '${widget.userbooking!.name} accepted your request for PKR ${widget.userbooking!.price}  They will arrive in ~10 min',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: Get.height * 0.7,
            left: 20,
            child: Container(
              height: 130,
              width: Get.width * .9,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Text(
                    '${widget.userbooking!.carcolour} MOTOR-BIKE Super Asia',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'SGL 7499',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(Iconsax.user),
                    ),
                    title: Text(
                      widget.userbooking!.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        Text(
                          '4.2',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
