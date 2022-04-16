import 'dart:convert';

class ProductModel
{
  final int id;
  final int id_seller;
  final String name_seller;
  final String name;
  final String price;
  final String detail;
  final String images;
  final String created_at;
  final String updated_at;

//<editor-fold desc="Data Methods">

  const ProductModel({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          id_seller == other.id_seller &&
          name_seller == other.name_seller &&
          name == other.name &&
          price == other.price &&
          detail == other.detail &&
          images == other.images &&
          created_at == other.created_at &&
          updated_at == other.updated_at);

  @override
  int get hashCode =>
      id.hashCode ^
      id_seller.hashCode ^
      name_seller.hashCode ^
      name.hashCode ^
      price.hashCode ^
      detail.hashCode ^
      images.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode;

  @override
  String toString() {
    return 'ProductModel{' +
        ' id: $id,' +
        ' id_seller: $id_seller,' +
        ' name_seller: $name_seller,' +
        ' name: $name,' +
        ' price: $price,' +
        ' detail: $detail,' +
        ' images: $images,' +
        ' created_at: $created_at,' +
        ' updated_at: $updated_at,' +
        '}';
  }

  ProductModel copyWith({
    int? id,
    int? id_seller,
    String? name_seller,
    String? name,
    String? price,
    String? detail,
    String? images,
    String? created_at,
    String? updated_at,
  }) {
    return ProductModel(
      id: id ?? this.id,
      id_seller: id_seller ?? this.id_seller,
      name_seller: name_seller ?? this.name_seller,
      name: name ?? this.name,
      price: price ?? this.price,
      detail: detail ?? this.detail,
      images: images ?? this.images,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'id_seller': this.id_seller,
      'name_seller': this.name_seller,
      'name': this.name,
      'price': this.price,
      'detail': this.detail,
      'images': this.images,
      'created_at': this.created_at,
      'updated_at': this.updated_at,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      id_seller: map['id_seller'] as int,
      name_seller: map['name_seller'] as String,
      name: map['name'] as String,
      price: map['price'] as String,
      detail: map['detail'] as String,
      images: map['images'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
    );
  }

//</editor-fold>
}