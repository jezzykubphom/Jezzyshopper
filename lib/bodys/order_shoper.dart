import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/order_model.dart';
import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderShoper extends StatefulWidget {
  const OrderShoper({Key? key}) : super(key: key);

  @override
  State<OrderShoper> createState() => _OrderShoperState();
}

class _OrderShoperState extends State<OrderShoper> {
  bool load = true;
  bool? haveOrder;
  var orderModels = <OrderModel>[];
  var userBuyerModels = <UserModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readerOrder();
  }

  Future<void> readerOrder() async {
    if (orderModels.isNotEmpty) {
      orderModels.clear();
      userBuyerModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? codeShoper = preferences.getString(MyConstant.keyUser);

    String urlAPI =
        'http://www.program2me.com/api/ungapi/myOrderGetShoper.php?codeshoper=$codeShoper';
    await Dio().get(urlAPI).then((value) async {
      // print('Value ==>> $value');

      if (value.toString() == 'null') {
        haveOrder = false;
      } else {
        haveOrder = true;

        for (var element in value.data) {
          OrderModel orderModel = OrderModel.fromMap(element);
          orderModels.add(orderModel);

          UserModel? userModel =
              await MyApi().findUserModel(user: orderModel.codebuyer);
          userBuyerModels.add(userModel!);
        }
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveOrder!
            ? ListView.builder(
                itemCount: orderModels.length,
                itemBuilder: (context, index) => ExpansionTile(
                  title: ShowText(label: userBuyerModels[index].Name),
                ),
              )
            : Center(
                child: ShowText(
                  label: 'ยังไม่มีคำสั่งซื้อ!!',
                  textStyle: MyConstant().h2Style(),
                ),
              );
  }
}
