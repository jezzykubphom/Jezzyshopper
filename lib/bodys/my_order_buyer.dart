import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/order_model.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/head_bill.dart';
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
          var nameProducts =
              MyCalulate().changeStriongToArray(string: orderModel.nameproduct);
          var priceProducts = MyCalulate()
              .changeStriongToArray(string: orderModel.priceproduct);
          var amountProducts = MyCalulate()
              .changeStriongToArray(string: orderModel.amountproduct);
          var sumProducts =
              MyCalulate().changeStriongToArray(string: orderModel.sumproduct);

          orderModels.add(orderModel);

          var widgets = <Widget>[];
          widgets.add(Column(
            children: [
              const HeadBill(),
              listOrder(
                  nameProducts, priceProducts, amountProducts, sumProducts),
              newTotal(orderModel),
            ],
          ));
          listWidgets.add(widgets);
        }
      }

      load = false;
      setState(() {});
    });
  }

  Row newTotal(OrderModel orderModel) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowText(
                label: 'Total : ',
                textStyle: MyConstant().h2Style(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ShowText(
            label: orderModel.total,
            textStyle: MyConstant().h3ActiveStyle(),
          ),
        ),
      ],
    );
  }

  ListView listOrder(List<String> nameProducts, List<String> priceProducts,
      List<String> amountProducts, List<String> sumProducts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: nameProducts.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 2,
            child: ShowText(label: nameProducts[index]),
          ),
          Expanded(
            flex: 1,
            child: ShowText(label: priceProducts[index]),
          ),
          Expanded(
            flex: 1,
            child: ShowText(label: amountProducts[index]),
          ),
          Expanded(
            flex: 1,
            child: ShowText(label: sumProducts[index]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveOrder!
            ? ListView.builder(
                itemCount: orderModels.length,
                itemBuilder: (context, index) => ExpansionTile(
                  title: Row(
                    children: [
                      ShowText(
                        label: orderModels[index].codeshoper,
                      ),
                      ShowText(label: '  (${orderModels[index].status})'),
                    ],
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
