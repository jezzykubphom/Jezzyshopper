// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class ShowMenu extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String? subTitle;
  final Function() pressFunc;

  const ShowMenu({
    Key? key,
    required this.iconData,
    required this.title,
    this.subTitle,
    required this.pressFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: MyConstant.dark,
        size: 36,
      ),
      title: ShowText(
        label: title,
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowText(label: subTitle ?? ''),
      onTap: pressFunc,
    );
  }
}
