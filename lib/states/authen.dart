import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_form.dart';
import 'package:jezzyshopping/widgets/show_image.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/show_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String? user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Container(
          decoration: MyConstant().mainBG(),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            newLogo(),
                            newTextLogin(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  formUser(),
                  formPassword(),
                  buttonLogin(),
                  newCreateAccount(context: context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row newCreateAccount({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ShowText(label: 'No Account ? '),
        ShowTextButton(
            label: 'Create Account',
            pressFunc: () {
              Navigator.pushNamed(context, MyConstant.routeCreateAccount);
            }),
      ],
    );
  }

  ShowBotton buttonLogin() {
    return ShowBotton(
      label: 'login',
      pressFunc: () {
        if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
          MyDialog(context: context).normalDailog(
              title: 'Have Space', SubTitle: 'Please Fill Every Blank');
        } else {
          checkAuthen();
        }
      },
    );
  }

  Future<void> checkAuthen() async {
    String urlCheckAuthen =
        'http://www.program2me.com/api/ungapi/getUserWhereUser.php?user=$user';
    await Dio().get(urlCheckAuthen).then((value) {
      if (value.toString() == 'null') {
        MyDialog(context: context).normalDailog(
            title: 'User False', SubTitle: 'No $user in My Database');
      } else {
        for (var element in value.data) {
          //print('element ==> $element');

          UserModel userModel = UserModel.fromMap(element);

          print('userMel ==> ${userModel.toMap()}');

          if (password == userModel.Password) {
            processSavePreUser(userModel: userModel);

            switch (userModel.Usertype) {
              case 'Buyer':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeBuyer, (route) => false);
                break;
              case 'Shoper':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeShopper, (route) => false);
                break;
              case 'Rider':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeRider, (route) => false);
                break;
              default:
            }
          } else {
            MyDialog(context: context).normalDailog(
                title: 'Password False', SubTitle: 'Please TryAgain Password');
          }
        }
      }
    });
  }

  Future<void> processSavePreUser({required UserModel userModel}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MyConstant.keyUser, userModel.Code);
    preferences.setString(MyConstant.keyTypeUser, userModel.Usertype);
  }

  ShowForm formPassword() {
    return ShowForm(
      obsecu: true,
      label: 'Password :',
      iconData: Icons.lock_outline,
      changeFunc: (String string) {
        password = string.trim();
      },
    );
  }

  ShowForm formUser() {
    return ShowForm(
      label: 'User :',
      iconData: Icons.perm_identity,
      changeFunc: (String string) {
        user = string.trim();
      },
    );
  }

  ShowText newTextLogin() => ShowText(
        label: 'login :',
        textStyle: MyConstant().h1Style(),
      );

  SizedBox newLogo() {
    return SizedBox(
      width: 80,
      child: ShowImage(),
    );
  }
}
