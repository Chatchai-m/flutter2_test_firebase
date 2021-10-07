import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String type;
  final String? address;
  final String? phone;
  final String user;
  final String password;
  final String? avata;
  final String? lat;
  final String? lng;
  final String? createdAt;
  final String? updatedAt;
  UserModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.phone,
    required this.user,
    required this.password,
    required this.avata,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? type,
    String? address,
    String? phone,
    String? user,
    String? password,
    String? avata,
    String? lat,
    String? lng,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      user: user ?? this.user,
      password: password ?? this.password,
      avata: avata ?? this.avata,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'phone': phone,
      'user': user,
      'password': password,
      'avata': avata,
      'lat': lat,
      'lng': lng,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      address: map['address'],
      phone: map['phone'],
      user: map['user'],
      password: map['password'],
      avata: map['avata'],
      lat: map['lat'],
      lng: map['lng'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, type: $type, address: $address, phone: $phone, user: $user, password: $password, avata: $avata, lat: $lat, lng: $lng, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.address == address &&
        other.phone == phone &&
        other.user == user &&
        other.password == password &&
        other.avata == avata &&
        other.lat == lat &&
        other.lng == lng &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        user.hashCode ^
        password.hashCode ^
        avata.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
