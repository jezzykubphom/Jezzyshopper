import 'package:flutter/material.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowMenu(
      iconData: Icons.exit_to_app,
      title: 'Sign Out',
      pressFunc: () {
        MyDialog(context: context).normalDailog(
            title: 'Sing Out ?',
            SubTitle: 'Are You sure!!',
            label: 'Sing Out',
            pressFunc: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear().then((value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeAuthen, (route) => false);
              });
            });
      },
      subTitle: 'SignOut Move To Authen',
    );
  }
}
