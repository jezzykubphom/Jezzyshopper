import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_sign_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopperService extends StatefulWidget {
  const ShopperService({Key? key}) : super(key: key);

  @override
  State<ShopperService> createState() => _ShopperServiceState();
}

class _ShopperServiceState extends State<ShopperService> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    processFindUserModel();
  }

  Future<void> processFindUserModel() async {
    print('processFindUserModel work');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString(MyConstant.keyUser);

    print('user ==> $user');

    userModel = await MyApi().findUserModel(user: user!);

    if (userModel != null) {
      print('userModel ==> ${userModel!.toMap()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(accountName: null, accountEmail: null),
            const Spacer(),
            ShowSignOut(),
          ],
        ),
      ),
    );
  }
}
