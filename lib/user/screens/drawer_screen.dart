import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liferfoodrider/driver/screens/profile_screen.dart';
import 'package:liferfoodrider/user/userController/userprofilecontroller.dart';

import '../../user/global/global.dart';
import '../../user/splashScreen/splash_screen.dart';

class User_Drawer extends StatelessWidget {
  User_Drawer({Key? key}) : super(key: key);
  final controller = Get.find<UserProfileGetUser>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.userModel.value.name ?? 'user',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Colors.grey),
                    ),
                    Text(
                      controller.userModel.value.email ?? 'user@gmail.com',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(Icons.person),
                          trailing: Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                          title: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => ProfileScreen()));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(Icons.trip_origin),
                          trailing: Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                          title: Text(
                            "Your Trips",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => YourTripScreen()));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(Icons.payment),
                          trailing: Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                          title: Text(
                            "Payment",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => DepositScreen()));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(Icons.notifications),
                          trailing: Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                          title: Text(
                            "Notifcations",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(Icons.person),
                          trailing: Icon(
                            Icons.pregnant_woman_outlined,
                            size: 16,
                          ),
                          title: Text(
                            "Promos",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => PromoScreen()));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(Icons.help),
                          trailing: Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                          title: Text(
                            "Help",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => HelpScreen()));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(Icons.person),
                          trailing: Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                          title: Text(
                            "Free Trips",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => YourTripScreen()));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: Card(
                    color: Colors.red.withOpacity(0.2),
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      trailing: Icon(
                        Icons.arrow_forward,
                        size: 16,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        firebaseAuth.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const SplashScreen()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DepositScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DepositController controller = Get.put(DepositController());

    return Scaffold(
      appBar: AppBar(title: Text('Deposit Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Amount'),
              onChanged: (value) {
                double amount = double.tryParse(value) ?? 0.0;
                controller.depositAmount.value = amount;
              },
            ),
            SizedBox(height: 20),
            Obx(() {
              return Text(
                'Amount Deposited: \$${controller.depositAmount.value.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RatingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RatingController controller = Get.put(RatingController());

    return Scaffold(
      appBar: AppBar(title: Text('Rating Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Rate us:'),
            Slider(
              min: 0,
              max: 5,
              divisions: 5,
              value: controller.rating.value,
              onChanged: (value) {
                controller.rating.value = value;
              },
            ),
            Obx(() {
              return Text(
                'Rating: ${controller.rating.value.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 24),
              );
            }),
          ],
        ),
      ),
    );
  }
}
// lib/controllers.dart

class DepositController extends GetxController {
  var depositAmount = 0.0.obs;
}

class RatingController extends GetxController {
  var rating = 0.0.obs;
}

// lib/promo_screen.dart

class PromoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Promotions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://img.freepik.com/free-vector/flat-car-rental-company-landing-page-template_23-2149254243.jpg?t=st=1724585417~exp=1724589017~hmac=f0f213d8248e67788909426ca2e8fec9daefc2e9eaefd05d9d595326bfdc9d50&w=900',
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              'Exclusive Offer!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Get 20% off on your next ride. Use code: RIDE20 at checkout.',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            SizedBox(
                width: 330,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text('Redeem Offer',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                )),
          ],
        ),
      ),
    );
  }
}

// lib/help_screen.dart

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('FAQ'),
              onTap: () {
                // Navigate to FAQ section
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact Us'),
              onTap: () {
                // Navigate to contact information
              },
            ),
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text('Email Support'),
              onTap: () {
                // Navigate to email support
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () {
                // Navigate to About Us
              },
            ),
          ],
        ),
      ),
    );
  }
}
// lib/your_trip_screen.dart

class YourTripScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Trip',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, size: 40),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: City A', style: TextStyle(fontSize: 18)),
                    Text('To: City B', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Scheduled Time: 2024-08-30 10:00 AM',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            SizedBox(
                width: 330,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text('View Detail',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                )),
          ],
        ),
      ),
    );
  }
}
