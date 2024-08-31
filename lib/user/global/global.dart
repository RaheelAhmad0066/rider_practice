import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../../driver/models/car_model.dart';
import '../../driver/models/driver_data.dart';
import '../../driver/models/user_ride_request_information.dart';
import '../models/active_nearby_drivers_type.dart';
import '../models/direction_details_info.dart';
import '../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

String cloudMessagingServerToken =
    "key=AAAA2uCAhQY:APA91bGALjOJa6XoHtHEqE4xSfFX5Q0mW9iWyeyliN4Iy42t2JsTukNV07XSFektAb5Hi6NzSAfY14cb-gUJ-5J4g0SZUkUBmt4YsiR53BhSExWb9Wlx_eQWAlS5X2-wTIO0_mUacaVT";

List driversList = [];
List<VehicleTypeInfo>? vehicleTypeInfoList = [];

DatabaseReference? referenceRideRequest;
String? rVehicleType;

DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String driverRatings = "";

double countRatingStars = 0.0;
String titleStarsRating = "Good";

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

CarModel? carModelCurrentInfo;
UserRideRequestInformation? userRideRequestInformation;

Position? driverCurrentPosition;

DriverData onlineDriverData = DriverData();

String? driverVehicleType = "";

RemoteMessage? savedRemoteMessage;
