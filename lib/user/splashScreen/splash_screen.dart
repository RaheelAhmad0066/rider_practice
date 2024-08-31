import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liferfoodrider/driver/screens/main_screend.dart';
import 'package:liferfoodrider/main.dart';

import '../../category.dart';
import '../Assistants/assistant_methods.dart';
import '../global/global.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("drivers");
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");

    if (currentUser == null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const categoryud()));
      });
      return;
    }

    try {
      // Checking if the current user is a driver
      final driverSnapshot = await driversRef.child(currentUser.uid).get();
      if (driverSnapshot.exists) {
        // Driver-specific logic
        print("Driver logged in.");
        Timer(const Duration(seconds: 2), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreend()));
        });
        return;
      }

      // Checking if the current user is a regular user
      final userSnapshot = await usersRef.child(currentUser.uid).get();
      if (userSnapshot.exists) {
        // User-specific logic
        print("User logged in.");
        Timer(const Duration(seconds: 2), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const UserMainScreen()));
        });
        return;
      }

      // Fallback if user type is not found
      print("User type not recognized.");
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const categoryud()));
      });
    } catch (e) {
      print("Error in retrieving data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'FemmeRide',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
