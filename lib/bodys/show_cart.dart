import 'package:flutter/material.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class ShowCart extends StatelessWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowText(label: 'This is Show Cart');
  }
}
