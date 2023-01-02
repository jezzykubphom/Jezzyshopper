import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/states/check_pin_code.dart';
import 'package:jezzyshopping/states/edit_informaiton.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/shwo_imag_internet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShoper extends StatefulWidget {
  const InformationShoper({Key? key}) : super(key: key);

  @override
  State<InformationShoper> createState() => _InformationShoperState();
}

class _InformationShoperState extends State<InformationShoper> {
  UserModel? userModel;
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processFindUserModel();
  }

  Future<void> processFindUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString(MyConstant.keyUser);

    await MyApi().findUserModel(user: user!).then((value) {
      userModel = value;

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
            return Stack(
              children: [
                ListView(
                  children: [
                    showValue(head: 'Name : ', value: userModel!.Name),
                    showValue(head: 'Address : ', value: userModel!.Address),
                    showValue(
                        head: 'Telephone : ', value: userModel!.Telephone),
                    SizedBox(
                      width: boxConstraints.maxWidth * 0.75,
                      height: boxConstraints.maxWidth * 0.75,
                      child: ShowImageInternet(path: userModel!.Picture),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: boxConstraints.maxWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowBotton(
                          label: 'Edit Information',
                          pressFunc: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckPinCode(),
                                )).then((value) {
                              print(
                                  '##4OCT ==>> value from information $value');

                              if (value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EidtInformation(
                                          userModel: userModel!),
                                    )).then((value) {
                                  load = true;
                                  processFindUserModel();
                                  setState(() {});
                                });
                              } else {
                                MyDialog(context: context).normalDailog(
                                    title: 'PinCode False',
                                    SubTitle: 'Please Fill Current PinCode');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
  }

  Padding showValue({required String head, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ShowText(
              label: head,
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowText(label: value),
          ),
        ],
      ),
    );
  }
}
