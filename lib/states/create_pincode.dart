import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jezzyshopping/states/shopper_service.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/show_text.dart';

class CreatePinCode extends StatefulWidget {
  const CreatePinCode({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePinCode> createState() => _CreatePinCodeState();
}

class _CreatePinCodeState extends State<CreatePinCode> {
  String? pinCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ShowIconButton(
            iconData:
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            pressFunc: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopperService(),
                  ),
                  (route) => false);
            }),
        title: ShowText(
          label: 'Create PinCode',
          textStyle: MyConstant().h2Style(),
        ),
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            ShowText(
              label: 'Create Pin Code',
              textStyle: MyConstant().h2Style(),
            ),
            const SizedBox(
              height: 16,
            ),
            OTPTextField(
              length: 6,
              width: 250,
              fieldStyle: FieldStyle.box,
              onCompleted: (value) async {
                pinCode = value.toString();
                print('This pincode ==>> $pinCode');

                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setString('pincode', pinCode!).then((value) {
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
