class UserBook {
  final String id;
  final String name;
  final String vehicle;
  final String carcolour;
  final String carmodal;
  final String typecar;
  final String phone;
  final double price;

  UserBook({
    required this.id,
    required this.name,
    required this.vehicle,
    required this.carcolour,
    required this.carmodal,
    required this.typecar,
    required this.phone,
    required this.price,
  });

  factory UserBook.fromJson(String id, Map<String, dynamic> json) {
    return UserBook(
      id: id,
      name: json['name'] ?? '',
      vehicle: json['vehicle'] ?? '',
      carcolour: json['carcolour'] ?? '',
      carmodal: json['carmodal'] ?? '',
      typecar: json['typecar'] ?? '',
      phone: json['phone'] ?? '',
      price: (json['price'] as num).toDouble(),
    );
  }
}
