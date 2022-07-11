import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  final String id;
  final String shopcode;
  final String code;
  final String name;
  final String unit;
  final String qty;
  final String price;
  final String picture;
  ProductModel({
    required this.id,
    required this.shopcode,
    required this.code,
    required this.name,
    required this.unit,
    required this.qty,
    required this.price,
    required this.picture,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shopcode': shopcode,
      'code': code,
      'name': name,
      'unit': unit,
      'qty': qty,
      'price': price,
      'picture': picture,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      shopcode: map['shopcode'] as String,
      code: map['code'] as String,
      name: map['name'] as String,
      unit: map['unit'] as String,
      qty: map['qty'] as String,
      price: map['price'] as String,
      picture: map['picture'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
