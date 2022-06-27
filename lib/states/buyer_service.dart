import 'package:flutter/material.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_menu.dart';
import 'package:jezzyshopping/widgets/show_sign_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerService extends StatelessWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
                accountName: null, accountEmail: null),
            const Spacer(),
            ShowSignOut()
          ],
        ),
      ),
    );
  }
}
