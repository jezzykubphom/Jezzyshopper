import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/order_model.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderBuyer extends StatefulWidget {
  const MyOrderBuyer({Key? key}) : super(key: key);

  @override
  State<MyOrderBuyer> createState() => _MyOrderBuyerState();
}

class _MyOrderBuyerState extends State<MyOrderBuyer> {
  String? codeBuyer;
  bool load = true;
  bool? haveOrder;

  var orderModels = <OrderModel>[];
  var listWidgets = <List<Widget>>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readMyOrder();
  }

  Future<void> readMyOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    codeBuyer = preferences.getString(MyConstant.keyUser);

    print('CodeBuyer ==> $codeBuyer');

    String path =
        'http://www.program2me.com/api/ungapi/myOrderGetBuyer.php?codebuyer=$codeBuyer';

    await Dio().get(path).then((value) {
      if (value.data == null) {
        haveOrder = false;
      } else {
        haveOrder = true;

        for (var element in value.data) {
          OrderModel orderModel = OrderModel.fromMap(element);
          orderModels.add(orderModel);

          var widgets = <Widget>[];
          widgets.add(Container(
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
          ));
          listWidgets.add(widgets);
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
                  title: ShowText(
                    label: orderModels[index].codeshoper,
                  ),
                  children: listWidgets[index],
                ),
              )
            : Center(
                child: ShowText(
                  label: 'No Order',
                  textStyle: MyConstant().h1Style(),
                ),
              );
  }
}
