import 'package:flutter/material.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

import '../utility/my_constant.dart';

class HeadBill extends StatelessWidget {
  const HeadBill({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(color: MyConstant.light),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ShowText(label: 'สินค้า'),
          ),
          Expanded(
            flex: 1,
            child: ShowText(label: 'ราคา'),
          ),
          Expanded(
            flex: 1,
            child: ShowText(label: 'จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: ShowText(label: 'รวม'),
          ),
        ],
      ),
    );
  }
}
