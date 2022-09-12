import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderModel {
  final String? id;
  final String codebuyer;
  final String codeshoper;
  final String idproduct;
  final String nameproduct;
  final String priceproduct;
  final String amountproduct;
  final String sumproduct;
  final String total;
  final String status;
  final String urlslip;
  final String? tdatetime;
  OrderModel({
    this.id,
    required this.codebuyer,
    required this.codeshoper,
    required this.idproduct,
    required this.nameproduct,
    required this.priceproduct,
    required this.amountproduct,
    required this.sumproduct,
    required this.total,
    required this.status,
    required this.urlslip,
    this.tdatetime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'codebuyer': codebuyer,
      'codeshoper': codeshoper,
      'idproduct': idproduct,
      'nameproduct': nameproduct,
      'priceproduct': priceproduct,
      'amountproduct': amountproduct,
      'sumproduct': sumproduct,
      'total': total,
      'status': status,
      'urlslip': urlslip,
      'tdatetime': tdatetime,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      codebuyer: map['codebuyer'] as String,
      codeshoper: map['codeshoper'] as String,
      idproduct: map['idproduct'] as String,
      nameproduct: map['nameproduct'] as String,
      priceproduct: map['priceproduct'] as String,
      amountproduct: map['amountproduct'] as String,
      sumproduct: map['sumproduct'] as String,
      total: map['total'] as String,
      status: map['status'] as String,
      urlslip: map['urlslip'] as String,
      tdatetime: map['tdatetime'] != null ? map['tdatetime'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
