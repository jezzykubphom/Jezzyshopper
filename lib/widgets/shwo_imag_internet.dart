// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ShowImageInternet extends StatelessWidget {
  final String path;
  final BoxFit? boxFit;
  const ShowImageInternet({
    Key? key,
    required this.path,
    this.boxFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      path,
      fit: boxFit ?? BoxFit.contain,
    );
  }
}
