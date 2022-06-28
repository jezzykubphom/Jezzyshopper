// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class ShowForm extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Function(String) changeFunc;
  final bool? obsecu;
  final TextEditingController? textEditingController;
  final double? width;
  final TextInputType? textInputType;
  const ShowForm({
    Key? key,
    required this.label,
    required this.iconData,
    required this.changeFunc,
    this.obsecu,
    this.textEditingController,
    this.width,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: width ?? 250,
      height: 40,
      child: TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        controller: textEditingController,
        obscureText: obsecu ?? false,
        onChanged: changeFunc,
        decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 4),
          prefixIcon: Icon(
            iconData,
            color: MyConstant.dark,
          ),
          label: ShowText(label: label),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyConstant.dark),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: MyConstant.light)),
        ),
      ),
    );
  }
}
