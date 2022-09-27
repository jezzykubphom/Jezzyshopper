import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/order_model.dart';
import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/head_bill.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_image.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/shwo_imag_internet.dart';
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

  var listWidgets = <List<Widget>>[];
  var totals = <int>[];

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
      listWidgets.clear();
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
          totals.add(0);

          OrderModel orderModel = OrderModel.fromMap(element);
          orderModels.add(orderModel);

          var products =
              MyCalulate().changeStriongToArray(string: orderModel.nameproduct);
          var prices = MyCalulate()
              .changeStriongToArray(string: orderModel.priceproduct);
          var amounts = MyCalulate()
              .changeStriongToArray(string: orderModel.amountproduct);
          var sums =
              MyCalulate().changeStriongToArray(string: orderModel.sumproduct);

          var widgets = <Widget>[];
          Widget widget = createWidget(
            products: products,
            prices: prices,
            amounst: amounts,
            sums: sums,
            orderModel: orderModel,
          );
          widgets.add(widget);
          listWidgets.add(widgets);

          UserModel? userModel =
              await MyApi().findUserModel(user: orderModel.codebuyer);
          userBuyerModels.add(userModel!);
        }
      }

      load = false;
      setState(() {});
    });
  }

  Widget createWidget({
    required List<String> products,
    required List<String> prices,
    required List<String> amounst,
    required List<String> sums,
    required OrderModel orderModel,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HeadBill(),
        ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) => Row(
            children: [
              Expanded(
                flex: 2,
                child: ShowText(label: products[index]),
              ),
              Expanded(
                flex: 1,
                child: ShowText(label: prices[index]),
              ),
              Expanded(
                flex: 1,
                child: ShowText(label: amounst[index]),
              ),
              Expanded(
                flex: 1,
                child: ShowText(label: sums[index]),
              ),
            ],
          ),
        ),
        Row(
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
                label: MyCalulate().moneyFormat(
                  money: MyCalulate().calulateTotal(sums: sums),
                ),
                textStyle: MyConstant().h3ActiveStyle(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            ShowText(
              label: 'Slip : ',
              textStyle: MyConstant().h2Style(),
            ),
          ],
        ),
        orderModel.urlslip.length == 1
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: ShowImage(
                  path: 'images/slip.php',
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShowImageInternet(
                  path: orderModel.urlslip,
                ),
              ),
        orderModel.status == 'order'
            ? ShowBotton(
                label: 'ตรวจสอบออเดอร์',
                pressFunc: () {
                  processCheckOrder(orderModel: orderModel);
                },
              )
            : orderModel.status == 'receive'
                ? ShowBotton(
                    label: 'หาคนส่งของ',
                    pressFunc: () {},
                  )
                : checkstatus(orderModel: orderModel)
                    ? ShowBotton(
                        label: 'Rider รับของแล้ว',
                        pressFunc: () async {
                          var strings = MyCalulate()
                              .changeStriongToArray(string: orderModel.status);

                          strings[1] = 'delivery';

                          String apiUpdateStatus =
                              'http://www.program2me.com/api/ungapi/myorder_updatestatus.php?id=${orderModel.id}}&status=${strings.toString()}';
                          await Dio().get(apiUpdateStatus).then((value) async {
                            UserModel? userModelBuyer = await MyApi()
                                .findUserModel(user: orderModel.codebuyer);
                            await MyApi()
                                .processSendNotification(
                                    token: userModelBuyer!.token,
                                    title: 'Rider Delivery',
                                    body: 'Rider กำลังไปส่งของให้คุณ')
                                .then((value) {
                              readerOrder();
                            });
                          });
                        },
                      )
                    : const SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveOrder!
            ? ListView.builder(
                itemCount: orderModels.length,
                itemBuilder: (context, index) => Card(
                  child: ExpansionTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShowText(
                          label: userBuyerModels[index].Name,
                          textStyle: MyConstant().h2Style(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShowText(
                              label: orderModels[index].tdatetime!,
                              textStyle: MyConstant().h3Style(),
                            ),
                            ShowText(
                              label: orderModels[index].status,
                              textStyle: orderModels[index].status == 'order'
                                  ? MyConstant().h3ActiveStyle()
                                  : MyConstant().h3GreenStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: listWidgets[index],
                  ),
                ),
              )
            : Center(
                child: ShowText(
                  label: 'ยังไม่มีคำสั่งซื้อ!!',
                  textStyle: MyConstant().h2Style(),
                ),
              );
  }

  Future<void> processCheckOrder({required OrderModel orderModel}) async {
    // Edit Status ==>> receive
    String pathEditStatus =
        'http://www.program2me.com/api/ungapi/myorder_updatestatus.php?id=${orderModel.id}&status=receive';

    await Dio().get(pathEditStatus).then((value) async {
      UserModel? userModelBuyer =
          await MyApi().findUserModel(user: orderModel.codebuyer);

      if (userModelBuyer != null) {
        await MyApi()
            .processSendNotification(
                token: userModelBuyer.token,
                title: 'ร้านค้ารับออเดอร์แล้ว',
                body: 'ร้านค้ากำลังหาคนส่งของให้ครับ')
            .then((value) {
          readerOrder();
        });
      }
    });

    // Noti ALL Rider
    processNotiToAllRider();
  }

  Future<void> processNotiToAllRider() async {
    String pathAPI =
        'http://www.program2me.com/api/ungapi/myOrderGetRiderNotWork.php';
    await Dio().get(pathAPI).then((value) async {
      if (value.toString() != 'null') {
        for (var element in value.data) {
          UserModel userModel = UserModel.fromMap(element);
          await MyApi().processSendNotification(
              token: userModel.token,
              title: 'มี Order ใหม่',
              body: 'มี Order ใหม่ กรุณากดรับงานด้วย');
        }
      } else {
        MyDialog(context: context).normalDailog(
            title: 'ไม่มี Rider ว่างขณะนี้',
            SubTitle: 'รอสักครู่ค่อยมากดหาคนส่งของใหม่');
      }
    });
  }

  bool checkstatus({required OrderModel orderModel}) {
    bool result = false;
    var strings = MyCalulate().changeStriongToArray(string: orderModel.status);
    print('String55 ==>> $strings');

    if (strings[1] == 'rider') {
      result = true;
    }
    return result;
  }
}
