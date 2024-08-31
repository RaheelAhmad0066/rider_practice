import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liferfoodrider/user/global/global.dart';
import 'package:liferfoodrider/user/infoHandler/app_info.dart';
import 'package:liferfoodrider/user/splashScreen/splash_screen.dart';
import 'package:liferfoodrider/user/themeProvider/theme_provider.dart';
import 'driver/pushNotification/push_notification_system.dart';
import 'driver/widgets/bookingcard.dart';
import 'user/userController/userprofilecontroller.dart';

late final SharedPreferences prefs;

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  //Fluttertoast.showToast(msg: 'A background message arrived: ${message.toString()}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(UserProfileGetUser());
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: Builder(builder: (context) {
          // Process the saved remote message if it exists
          if (savedRemoteMessage != null) {
            PushNotificationSystem.readUserRideRequestInformation(
                savedRemoteMessage?.data["rideRequestId"], context);
            savedRemoteMessage = null; // Clear the saved message
          }
          // Your normal home page
          return SplashScreen();
        }),
      ),
    );
  }
}
