import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jezzyshopping/states/create_pincode.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_image.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class CheckPinCode extends StatefulWidget {
  const CheckPinCode({Key? key}) : super(key: key);

  @override
  State<CheckPinCode> createState() => _CheckPinCodeState();
}

class _CheckPinCodeState extends State<CheckPinCode> {
  bool result = false; // false ==> False Pincode

  String? truePinCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentPinCode();
  }

  Future<void> findCurrentPinCode() async {
    truePinCode = await MyCalulate().processFindMyPinCode();

    if (truePinCode?.isEmpty ?? true) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreatePinCode(),
          )).then((value) {
        findCurrentPinCode();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowText(
          label: 'Check PinCode',
          textStyle: MyConstant().h2Style(),
        ),
        leading: ShowIconButton(
          iconData:
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          pressFunc: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: boxConstraints.maxWidth * 0.75 - 50,
                child: const ShowImage(),
              ),
              OTPTextField(
                length: 6,
                width: 250,
                fieldStyle: FieldStyle.box,
                otpFieldStyle:
                    OtpFieldStyle(backgroundColor: Colors.grey.shade300),
                onCompleted: (value) {
                  String pinCode = value;
                  checkPin(pinCode: pinCode);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> checkPin({required String pinCode}) async {
    if (truePinCode == pinCode) {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
