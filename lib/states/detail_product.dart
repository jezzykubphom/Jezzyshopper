// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/show_title%20.dart';
import 'package:jezzyshopping/widgets/shwo_imag_internet.dart';

class DetialProduct extends StatefulWidget {
  final ProductModel productModel;
  const DetialProduct({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  State<DetialProduct> createState() => _DetialProductState();
}

class _DetialProductState extends State<DetialProduct> {
  ProductModel? productModel;
  var pictures = <String>[];
  int amount = 1;

  @override
  void initState() {
    super.initState();
    productModel = widget.productModel;
    pictures = MyCalulate().changeStriongToArray(string: productModel!.picture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            listProduct(constraints),
            ShowTitle(title: 'ราคา ${productModel!.price} บาท'),
            ShowTitle(
                title: 'จำนวน ${productModel!.qty} ${productModel!.unit}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowIconButton(
                  color: Colors.red,
                  size: 36,
                  iconData: Icons.remove_circle_outline,
                  pressFunc: () {
                    if (amount > 1) {
                      amount--;
                    }
                    setState(() {});
                  },
                ),
                ShowText(
                  label: amount.toString(),
                  textStyle: MyConstant().h1Style(),
                ),
                ShowIconButton(
                  color: Colors.green,
                  size: 36,
                  iconData: Icons.add_circle_outline,
                  pressFunc: () {
                    if (amount < double.parse(productModel!.qty).toInt()) {
                      amount++;
                    }

                    setState(() {});
                  },
                )
              ],
            ),
            ShowBotton(
              label: 'Add Cart',
              pressFunc: () {},
            ),
          ],
        ),
      ),
    );
  }

  SizedBox listProduct(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxWidth * 0.75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: pictures.length,
        itemBuilder: (context, index) =>
            ShowImageInternet(path: pictures[index]),
      ),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      centerTitle: true,
      title: ShowText(
        label: productModel!.name,
        textStyle: MyConstant().h2Style(),
      ),
      foregroundColor: MyConstant.dark,
      flexibleSpace: Container(
        decoration: MyConstant().mainAppBar(),
      ),
    );
  }
}
