import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Import vibration package
import '../controller/bookingcontroller.dart';
import '../models/bookingmodal.dart';
import '../widgets/bookingcard.dart';

class BookingScreen extends StatelessWidget {
  final BookingController controller = BookingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookings"),
      ),
      body: StreamBuilder(
        stream: controller.getBookingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching bookings"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No bookings available"));
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
    );
  }
}
