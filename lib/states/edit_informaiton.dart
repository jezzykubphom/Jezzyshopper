// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
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
  File? file;
  bool change = false; // false => non change all

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
          return Stack(
            children: [
              ListView(
                children: [
                  newImage(boxConstraints),
                  formName(),
                  formAddress(),
                  fromTelephone(),
                ],
              ),
              buttonEdit(boxConstraints)
            ],
          );
        }),
      ),
    );
  }

  Row formAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowForm(
          textEditingController: addressController,
          label: 'Address',
          iconData: Icons.home_mini_outlined,
          changeFunc: (String string) {
            change = true;
          },
        ),
      ],
    );
  }

  Positioned buttonEdit(BoxConstraints boxConstraints) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: boxConstraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShowBotton(
              label: 'Edit Information',
              pressFunc: () {
                if (change) {
                  print('Have Change');
                } else {
                  MyDialog(context: context).normalDailog(
                      title: 'Non Change',
                      SubTitle:
                          'Please Change Image , Name , Address , Telephone');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processTackPhoto({required ImageSource source}) async {
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    file = File(result!.path);
    change = true;
    setState(() {});
  }

  Row newImage(BoxConstraints boxConstraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            SizedBox(
              width: boxConstraints.maxWidth * 0.75,
              height: boxConstraints.maxWidth * 0.75,
              child: file == null
                  ? ShowImageInternet(path: userModel!.Picture)
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        file!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ShowIconButton(
                iconData: Icons.add_a_photo,
                pressFunc: () {
                  MyDialog(context: context).normalDailog(
                      label: 'Camera',
                      pressFunc: () {
                        Navigator.pop(context);
                        processTackPhoto(source: ImageSource.camera);
                      },
                      label2: 'Gallery',
                      pressFunc2: () {
                        Navigator.pop(context);
                        processTackPhoto(source: ImageSource.gallery);
                      },
                      title: 'Take Photo',
                      SubTitle: 'Please Take Photo by tab Camera or Gallery');
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Row fromTelephone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowForm(
          textEditingController: telephoneController,
          label: 'Telephone',
          iconData: Icons.phone,
          changeFunc: (String string) {
            change = true;
          },
        ),
      ],
    );
  }

  Row formName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowForm(
          textEditingController: nameController,
          label: 'Name',
          iconData: Icons.fingerprint,
          changeFunc: (String string) {
            change = true;
          },
        ),
      ],
    );
  }
}
