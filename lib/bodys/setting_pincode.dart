import 'package:flutter/material.dart';
import 'package:jezzyshopping/states/check_pin_code.dart';
import 'package:jezzyshopping/states/shopper_service.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/states/create_pincode.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPincode extends StatefulWidget {
  const SettingPincode({Key? key}) : super(key: key);

  @override
  State<SettingPincode> createState() => _SettingPincodeState();
}

class _SettingPincodeState extends State<SettingPincode> {
  String? myPinCode;
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findMyPinCode();
  }

  Future<void> findMyPinCode() async {
    myPinCode = await MyCalulate().processFindMyPinCode();
    print('##4OCTmyPinCode ==>> $myPinCode');

    if (myPinCode?.isEmpty ?? true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreatePinCode(),
        ),
      ).then((value) {
        findMyPinCode();
      });
    }

    load = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : myPinCode == null
            ? const SizedBox()
            : Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    ShowText(
                      label: coverPinCode(),
                      textStyle: MyConstant().h1Style(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShowBotton(
                            width: 150,
                            label: 'Change PinCode',
                            pressFunc: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CheckPinCode(),
                                  )).then((value) {
                                bool result = value;
                                print('##Result Check PinCode ==>> $result');

                                if (result) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreatePinCode(),
                                      )).then((value) => findMyPinCode());
                                } else {
                                  MyDialog(context: context).normalDailog(
                                      title: 'PinCode False',
                                      SubTitle: 'กรุณากรอก PinCode ให้ถูกต้อง');
                                }
                              });
                            }),
                        ShowBotton(
                          color: Colors.red.shade700,
                          width: 150,
                          label: 'Clear PinCode',
                          pressFunc: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckPinCode(),
                                )).then((value) async {
                              if (value) {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences
                                    .setString('pincode', '')
                                    .then((value) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ShopperService(),
                                      ),
                                      (route) => false);
                                });
                              } else {
                                MyDialog(context: context).normalDailog(
                                    title: 'PinCode False',
                                    SubTitle: 'Please Fill Current PinCode');
                              }
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
  }

  String coverPinCode() {
    String result = '***';
    String string = '';
    if (myPinCode!.length >= 6) {
      string = myPinCode!.substring(3, 6);
    }
    result = '$result $string';
    return result;
  }
}
