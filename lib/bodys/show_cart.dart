import 'package:flutter/material.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/sqlite_helper.dart';
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
            ? ShowText(label: 'Have Data')
            : Center(
              child: ShowText(
                  label: 'No Cart',
                  textStyle: MyConstant().h1Style(),
                ),
            );
  }
}
