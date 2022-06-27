// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_image.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/show_text_button.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  Future<void> normalDailog(
      {required String title,
      required String SubTitle,
      String? label,
      Function()? pressFunc}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: const SizedBox(
            width: 80,
            height: 80,
            child: ShowImage(),
          ),
          title: ShowText(
            label: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(label: SubTitle),
        ),
        actions: [
          ShowTextButton(
              label: label ?? 'OK',
              pressFunc: pressFunc ??
                  () {
                    Navigator.pop(context);
                  })
        ],
      ),
    );
  }
}
