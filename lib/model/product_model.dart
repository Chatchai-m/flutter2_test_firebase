import 'dart:convert';

class ProductModel
{
  final String id;
  final String id_seller;
  final String name_seller;
  final String name;
  final String price;
  final String detail;
  final String images;
  final String created_at;
  final String updated_at;

  ProductModel({
    required this.id,
    required this.id_seller,
    required this.name_seller,
    required this.name,
    required this.price,
    required this.detail,
    required this.images,
    required this.created_at,
    required this.updated_at,
  });

  ProductModel copyWith({
    String? id,
    String? id_seller,
    String? name_seller,
    String? name,
    String? price,
    String? detail,
    String? images,
    String? created_at,
    String? updated_at,
  }) {
    return ProductModel(
      id : id ?? this.id,
      id_seller : id_seller ?? this.id_seller,
      name_seller : name_seller ?? this.name_seller,
      name : name ?? this.name,
      price : price ?? this.price,
      detail : detail ?? this.detail,
      images : images ?? this.images,
      created_at : created_at ?? this.created_at,
      updated_at : updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'id_seller' : id_seller,
      'name_seller' : name_seller,
      'name' : name,
      'price' : price,
      'detail' : detail,
      'images' : images,
      'created_at' : created_at,
      'updated_at' : updated_at,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id : map['id'],
      id_seller : map['id_seller'],
      name_seller : map['name_seller'],
      name : map['name'],
      price : map['price'],
      detail : map['detail'],
      images : map['images'],
      created_at : map['created_at'],
      updated_at : map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, id_seller: $id_seller, name_seller: $name_seller, name: $name, price: $price, detail: $detail, images: $images, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.id_seller == id_seller &&
        other.name_seller == name_seller &&
        other.name == name &&
        other.price == price &&
        other.detail == detail &&
        other.images == images &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return
    id.hashCode ^
    id_seller.hashCode ^
    name_seller.hashCode ^
    name.hashCode ^
    price.hashCode ^
    detail.hashCode ^
    images.hashCode ^
    created_at.hashCode ^
    updated_at.hashCode;
  }
}