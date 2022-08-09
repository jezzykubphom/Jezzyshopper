import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/sqlite_model.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/sqlite_helper.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllSQLite();
  }

  Future<void> readAllSQLite() async {
    await SQLiteHelper().readAllSQLite().then((value) {
      print('Value read SQLite ==>> $value');

      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        sqliteModels = value;

        for (var element in sqliteModels) {
          int sum = int.parse(element.sum);
          total = total + sum;
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
                ],
              )
            : Center(
                child: ShowText(
                  label: 'No Cart',
                  textStyle: MyConstant().h1Style(),
                ),
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
      itemBuilder: (context, index) => Column(
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
                  iconData: Icons.edit_outlined,
                  pressFunc: () {},
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
