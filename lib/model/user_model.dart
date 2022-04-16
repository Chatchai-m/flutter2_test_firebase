class UserModel
{
  final int id;
  final String name;
  final String type;
  final String? address;
  final String? phone;
  final String user;
  final String password;
  final String? avata;
  final String? lat;
  final String? lng;
  final String? created_at;
  final String? updated_at;

//<editor-fold desc="Data Methods">

  const UserModel({
    required this.id,
    required this.name,
    required this.type,
    this.address,
    this.phone,
    required this.user,
    required this.password,
    this.avata,
    this.lat,
    this.lng,
    this.created_at,
    this.updated_at,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          address == other.address &&
          phone == other.phone &&
          user == other.user &&
          password == other.password &&
          avata == other.avata &&
          lat == other.lat &&
          lng == other.lng &&
          created_at == other.created_at &&
          updated_at == other.updated_at);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      address.hashCode ^
      phone.hashCode ^
      user.hashCode ^
      password.hashCode ^
      avata.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' type: $type,' +
        ' address: $address,' +
        ' phone: $phone,' +
        ' user: $user,' +
        ' password: $password,' +
        ' avata: $avata,' +
        ' lat: $lat,' +
        ' lng: $lng,' +
        ' created_at: $created_at,' +
        ' updated_at: $updated_at,' +
        '}';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? type,
    String? address,
    String? phone,
    String? user,
    String? password,
    String? avata,
    String? lat,
    String? lng,
    String? created_at,
    String? updated_at,
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
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'type': this.type,
      'address': this.address,
      'phone': this.phone,
      'user': this.user,
      'password': this.password,
      'avata': this.avata,
      'lat': this.lat,
      'lng': this.lng,
      'created_at': this.created_at,
      'updated_at': this.updated_at,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      user: map['user'] as String,
      password: map['password'] as String,
      avata: map['avata'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
    );
  }

//</editor-fold>
}