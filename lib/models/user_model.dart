// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String Code;
  final String Password;
  final String Usertype;
  final String Name;
  final String Address;
  final String Telephone;
  final String Picture;
  final String Picimage;
  final String lat;
  final String lng;
  final String token;
  UserModel({
    required this.Code,
    required this.Password,
    required this.Usertype,
    required this.Name,
    required this.Address,
    required this.Telephone,
    required this.Picture,
    required this.Picimage,
    required this.lat,
    required this.lng,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Code': Code,
      'Password': Password,
      'Usertype': Usertype,
      'Name': Name,
      'Address': Address,
      'Telephone': Telephone,
      'Picture': Picture,
      'Picimage': Picimage,
      'lat': lat,
      'lng': lng,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      Code: (map['Code'] ?? '') as String,
      Password: (map['Password'] ?? '') as String,
      Usertype: (map['Usertype'] ?? '') as String,
      Name: (map['Name'] ?? '') as String,
      Address: (map['Address'] ?? '') as String,
      Telephone: (map['Telephone'] ?? '') as String,
      Picture: (map['Picture'] ?? '') as String,
      Picimage: (map['Picimage'] ?? '') as String,
      lat: (map['lat'] ?? '') as String,
      lng: (map['lng'] ?? '') as String,
      token: (map['token'] ?? '') as String,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
