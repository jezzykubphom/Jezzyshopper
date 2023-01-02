// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jezzyshopping/utility/my_constant.dart';

class ShowBotton extends StatelessWidget {
  final String label;
  final Function() pressFunc;
  final double? width;
  final Color? color;

  const ShowBotton({
    Key? key,
    required this.label,
    required this.pressFunc,
    this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: width ?? 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? MyConstant.dark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: pressFunc,
        child: Text(label),
      ),
    );
  }
}
