// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/widgets/show_form.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/shwo_imag_internet.dart';

import '../utility/my_constant.dart';

class EidtInformation extends StatefulWidget {
  final UserModel userModel;
  const EidtInformation({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<EidtInformation> createState() => _EidtInformationState();
}

class _EidtInformationState extends State<EidtInformation> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    userModel = widget.userModel;
    nameController.text = userModel!.Name;
    addressController.text = userModel!.Address;
    telephoneController.text = userModel!.Telephone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowText(
          label: 'Edit Information',
          textStyle: MyConstant().h2Style(),
        ),
        foregroundColor: MyConstant.dark,
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowForm(
                    textEditingController: nameController,
                    label: 'Name',
                    iconData: Icons.fingerprint,
                    changeFunc: (String string) {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowForm(
                    textEditingController: addressController,
                    label: 'Address',
                    iconData: Icons.home_mini_outlined,
                    changeFunc: (String string) {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowForm(
                    textEditingController: telephoneController,
                    label: 'Telephone',
                    iconData: Icons.phone,
                    changeFunc: (String string) {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    width: boxConstraints.maxWidth * 0.75,
                    height: boxConstraints.maxWidth * 0.75,
                    child: Stack(
                      children: [
                        ShowImageInternet(path: userModel!.Picture),
                        ShowIconButton(
                          iconData: Icons.add_a_photo,
                          pressFunc: () {},
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
