class UserDB {
  String? name;
  double? toLocationlongitude;
  double? toLocationlatitude;
  double? fromlongitude;
  double? fromlatitude;
  String? fromLocationAddress;
  String? vehicale;
  String? id;
  String? toLocationAddress;
  int? price;

  UserDB({
    this.name,
    this.toLocationlatitude,
    this.toLocationlongitude,
    this.fromlatitude,
    this.id,
    this.vehicale,
    this.fromlongitude,
    this.fromLocationAddress,
    this.toLocationAddress,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'vehicle': vehicale,
      'tolocationlongitude': toLocationlongitude,
      'tolocationlatitude': toLocationlongitude,
      'fromlocationlongitude': fromlongitude,
      'fromlocationlatitude': fromlatitude,
      'fromLocationAddress': fromLocationAddress,
      'toLocationAddress': toLocationAddress,
      'price': price,
    };
  }
}
