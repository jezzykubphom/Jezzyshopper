import 'package:flutter/material.dart';
import 'package:jezzyshopping/states/add_product_shoper.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProductShoper extends StatefulWidget {
  const ManageProductShoper({Key? key}) : super(key: key);

  @override
  State<ManageProductShoper> createState() => _ManageProductShoperState();
}

class _ManageProductShoperState extends State<ManageProductShoper> {
  String? shopCode;

  @override
  void initState() {
    super.initState();
    readMyPorduct();
  }

  Future<void> readMyPorduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopCode = preferences.getString(MyConstant.keyUser);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowText(label: 'This is Manage Product Page'),
        Spacer(),
        buttonAddProduct(),
      ],
    );
  }

  Row buttonAddProduct() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowBotton(
          label: 'Add New Product',
          pressFunc: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProductShoper(shopCode: shopCode!),
              ),
            );
          },
        ),
      ],
    );
  }
}
