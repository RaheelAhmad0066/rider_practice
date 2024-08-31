class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? rid;
  String? status;
  String? type;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.rid,
    this.status,
    this.type,
  });

  // Factory constructor to create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      rid: map['rid'],
      status: map['status'],
      type: map['type'],
    );
  }
}

class DriverModal {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? rid;
  String? status;
  String? type;

  DriverModal({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.rid,
    this.status,
    this.type,
  });

  // Factory constructor to create a DriverModal from a Map
  factory DriverModal.fromMap(Map<String, dynamic> map) {
    return DriverModal(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      rid: map['rid'],
      status: map['status'],
      type: map['type'],
    );
  }
}

class DriverModel {
  String? address;
  CarDetails? carDetails;
  String? email;
  String? id;
  String? name;
  String? status;
  String? phone;
  String? token;
  String? ride;
  String? type;

  DriverModel({
    this.address,
    this.ride,
    this.carDetails,
    this.status,
    this.phone,
    this.token,
    this.type,
    this.email,
    this.id,
    this.name,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      address: map['address'] ?? '',
      carDetails: map['car_details'] != null
          ? CarDetails.fromMap(Map<String, dynamic>.from(map['car_details']))
          : null,
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      status: map['status'] ?? '',
      ride: map['ride'] ?? '',
      token: map['token'] ?? '',
      type: map['type'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}

class CarDetails {
  String? carColor;
  String? carModel;
  String? carNumber;
  String? type;

  CarDetails({
    this.carColor,
    this.carModel,
    this.carNumber,
    this.type,
  });

  factory CarDetails.fromMap(Map<String, dynamic> map) {
    return CarDetails(
      carColor: map['car_color'] ?? '',
      carModel: map['car_model'] ?? '',
      carNumber: map['car_number'] ?? '',
      type: map['type'] ?? '',
    );
  }
}
