class Booking {
  String bookingId;
  String fromLocationAddress;
  double fromLocationLatitude;
  double fromLocationLongitude;
  String toLocationAddress;
  double toLocationLatitude;
  double toLocationLongitude;
  String name;
  String vehicle;
  int price;

  Booking({
    required this.bookingId,
    required this.fromLocationAddress,
    required this.fromLocationLatitude,
    required this.fromLocationLongitude,
    required this.toLocationAddress,
    required this.toLocationLatitude,
    required this.toLocationLongitude,
    required this.name,
    required this.vehicle,
    required this.price,
  });

  factory Booking.fromJson(String id, Map<String, dynamic> json) {
    return Booking(
      bookingId: id,
      fromLocationAddress: json['fromLocationAddress'],
      fromLocationLatitude: json['fromlocationlatitude'],
      fromLocationLongitude: json['fromlocationlongitude'],
      toLocationAddress: json['toLocationAddress'],
      toLocationLatitude: json['tolocationlatitude'] ?? '',
      toLocationLongitude: json['tolocationlongitude'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      vehicle: json['vehicle'] ?? '',
    );
  }
}
