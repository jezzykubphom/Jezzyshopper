import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/models/sqlite_model.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/utility/sqlite_helper.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_image.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/show_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  bool load = true;
  bool? haveData;
  var sqliteModels = <SQLiteModel>[];
  int total = 0;
  var qtys = <String>[];
  String? codeBuyer;

  var idProducts = <String>[];
  var names = <String>[];
  var prices = <String>[];
  var amounts = <String>[];
  var sums = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllSQLite();
    findUserBuyer();
  }

  void findUserBuyer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    codeBuyer = preferences.getString(MyConstant.keyUser);

    print('codeBuyer ==>> $codeBuyer');
  }

  Future<void> readAllSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
      qtys.clear();
      total = 0;
      idProducts.clear();
      names.clear();
      prices.clear();
      amounts.clear();
      sums.clear();
    }

    await SQLiteHelper().readAllSQLite().then((value) async {
      print('Value read SQLite ==>> $value');

      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        sqliteModels = value;

        for (var element in sqliteModels) {
          int sum = int.parse(element.sum);
          total = total + sum;

          ProductModel? productModel =
              await MyApi().fideProductModel(idProduct: element.productId);
          if (productModel != null) {
            qtys.add(productModel.qty);
          }
          idProducts.add(element.productId);
          names.add(element.name);
          prices.add(element.price);
          amounts.add(element.amount);
          sums.add(element.sum);
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
        : haveData!
            ? Column(
                children: [
                  newHead(),
                  listProduct(),
                  newTotal(),
                  newButton(),
                ],
              )
            : Center(
                child: ShowText(
                  label: 'No Cart',
                  textStyle: MyConstant().h1Style(),
                ),
              );
  }

  Row newButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ShowBotton(
          width: 150,
          label: 'Empty Cart',
          pressFunc: () {
            MyDialog(context: context).normalDailog(
              title: 'Empty Cart',
              SubTitle: 'Please Confimr Empty Cart',
              label: 'Confirm',
              pressFunc: () async {
                Navigator.pop(context);

                await SQLiteHelper().clearSQLite().then((value) {
                  readAllSQLite();
                });
              },
              label2: 'Cancel',
              pressFunc2: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        ShowBotton(
          width: 150,
          label: 'Order',
          pressFunc: () {
            processOrderProduct();
          },
        ),
      ],
    );
  }

  Row newTotal() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowText(
                label: 'รวมสุทธิ :',
                textStyle: MyConstant().h2Style(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: ShowText(
            label: total.toString(),
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }

  Container newHead() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(color: MyConstant.light),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ShowText(
              label: 'ชื่อ',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              label: 'ราคา',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              label: 'จำนวน',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              label: 'รวม',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  ListView listProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) {
        return Dismissible(
            key: Key(
              sqliteModels[index].id.toString(),
            ),
            onDismissed: (direction) async {
              print('Delete ID : ${sqliteModels[index].id}');

              await SQLiteHelper()
                  .deleteValueWhereId(idDelete: sqliteModels[index].id!)
                  .then((value) {
                readAllSQLite();
              });
            },
            background: Container(
              decoration: BoxDecoration(color: Colors.red),
              child: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.white,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ShowText(label: sqliteModels[index].name),
                    ),
                    Expanded(
                      flex: 1,
                      child: ShowText(label: sqliteModels[index].price),
                    ),
                    Expanded(
                      flex: 1,
                      child: ShowText(label: sqliteModels[index].amount),
                    ),
                    Expanded(
                      flex: 1,
                      child: ShowText(label: sqliteModels[index].sum),
                    ),
                    Expanded(
                      flex: 1,
                      child: ShowIconButton(
                        color: Colors.purple,
                        iconData: Icons.edit_outlined,
                        pressFunc: () {
                          processEditAmount(context, index);
                        },
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ));
      },
    );
  }

  Future<void> processEditAmount(BuildContext context, int index) async {
    int amount = int.parse(sqliteModels[index].amount);
    int maxAmount = double.parse(qtys[index]).toInt();

    print('qty ==>> ${qtys[index]}');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, mySetState) {
        return AlertDialog(
          title: ListTile(
            leading: const SizedBox(
              width: 80,
              child: ShowImage(),
            ),
            title: ShowText(
              label: sqliteModels[index].name,
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: ShowText(label: 'ระบุจำนวนสินค้าใหม่'),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowIconButton(
                iconData: Icons.remove_circle,
                pressFunc: () {
                  if (amount > 1) {
                    amount--;
                  }

                  mySetState(() {});
                },
              ),
              ShowText(
                label: amount.toString(),
                textStyle: MyConstant().h2Style(),
              ),
              ShowIconButton(
                iconData: Icons.add_circle,
                pressFunc: () {
                  if (amount < maxAmount) {
                    amount++;
                  }
                  mySetState(() {});
                },
              ),
            ],
          ),
          actions: [
            ShowTextButton(
              label: 'Edit',
              pressFunc: () async {
                Navigator.pop(context);

                // print('amount ที่ต้องการ  replace ==>> $amount');

                int sumInt =
                    amount * double.parse(sqliteModels[index].price).toInt();

                Map<String, dynamic> map = sqliteModels[index].toMap();
                map['amount'] = amount.toString();
                map['sum'] = sumInt.toString();

                SQLiteModel sqLiteModelNew = SQLiteModel.fromMap(map);

                // print('SQLitemodelNew ==>> ${sqLiteModelNew.toMap()}');

                await SQLiteHelper()
                    .editAmount(
                        idEdit: sqLiteModelNew.id!, sqLiteModel: sqLiteModelNew)
                    .then((value) {
                  readAllSQLite();
                });
              },
            ),
            ShowTextButton(
              label: 'Cancel',
              pressFunc: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }),
    );
  }

  Future<void> processOrderProduct() async {
    String urlAPI =
        'http://www.program2me.com/api/ungapi/insertOrder.php?codebuyer=$codeBuyer&codeshoper=${sqliteModels[0].shopcode}&idproduct=${idProducts.toString()}&nameproduct=${names.toString()}&priceproduct=${prices.toString()}&amountproduct=${amounts.toString()}&sumproduct=$sums&total=$total';

    // print('urlAPI ==>> $urlAPI');

    await Dio().get(urlAPI).then((value) async {
      // print('Order Success');
      await SQLiteHelper().clearSQLite().then((value) {
        readAllSQLite();
        MyDialog(context: context).normalDailog(
            title: 'Order Success',
            SubTitle: 'ขอบคุณที่ใช้บริการ กรุณารอรับการยืนยัยจากร้านค้า');
      });
    });
  }
}
