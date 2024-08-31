import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class UserProfileGetUser extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchDriverData();
  }

  void fetchUserData() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(userId);

        DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          Map<String, dynamic> userMap =
              Map<String, dynamic>.from(snapshot.value as Map);
          userModel.value = UserModel.fromMap(userMap);
        } else {
          // Handle the case where the user ID does not exist in Realtime Database
          print('User not found');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Rx<DriverModel> driverModel = DriverModel().obs;

  void fetchDriverData() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        DatabaseReference driverRef =
            FirebaseDatabase.instance.ref().child('drivers').child(userId);
        DataSnapshot snapshot = await driverRef.get();
        if (snapshot.exists) {
          Map<String, dynamic> driverMap =
              Map<String, dynamic>.from(snapshot.value as Map);
          driverModel.value = DriverModel.fromMap(driverMap);
        } else {
          // Handle the case where the driver ID does not exist in Realtime Database
          print('Driver not found');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
