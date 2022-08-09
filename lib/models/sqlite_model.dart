import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SQLiteModel {
  final int? id;
  final String shopcode;
  final String nameshop;
  final String productId;
  final String name;
  final String unit;
  final String price;
  final String amount;
  final String sum;
  SQLiteModel({
    this.id,
    required this.shopcode,
    required this.nameshop,
    required this.productId,
    required this.name,
    required this.unit,
    required this.price,
    required this.amount,
    required this.sum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shopcode': shopcode,
      'nameshop': nameshop,
      'productId': productId,
      'name': name,
      'unit': unit,
      'price': price,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'] != null ? map['id'] as int : null,
      shopcode: map['shopcode'] as String,
      nameshop: map['nameshop'] as String,
      productId: map['productId'] as String,
      name: map['name'] as String,
      unit: map['unit'] as String,
      price: map['price'] as String,
      amount: map['amount'] as String,
      sum: map['sum'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
