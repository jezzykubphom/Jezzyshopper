import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_form.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_image.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  var typeUsers = MyConstant.typeUsers;
  String? typeUser, token, name, user, password;
  double? lat, lng;

  @override
  void initState() {
    super.initState();
    findLatLng();
    findToken();
  }

  Future<void> findToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value;
      print('token - $token');
    });
  }

  Future<void> findLatLng() async {
    Position position = await findPosition();
    lat = position.latitude;
    lng = position.longitude;
    print('lat = $lat, lng = $lng');
    setState(() {});
  }

  Future<Position> findPosition() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      MyDialog(context: context).normalDailog(
        title: 'Location Off',
        SubTitle: 'Please Open Location Service',
        label: 'Exit App',
        pressFunc: () {
          exit(0);
        },
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      MyDialog(context: context).normalDailog(
        title: 'Denied Forever',
        SubTitle: 'Please Permissing Location',
        label: 'Exit App',
        pressFunc: () {
          exit(0);
        },
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if ((permission != LocationPermission.whileInUse) &&
          (permission != LocationPermission.always)) {
        MyDialog(context: context).normalDailog(
          title: 'Denied Forever',
          SubTitle: 'Please Permission Locaiton',
          label: 'Exit App',
          pressFunc: () {
            exit(0);
          },
        );
      }
    }
    return await Geolocator.getCurrentPosition();
  } // end

  Future<void> processCreateAccount() async {
    if ((name?.isEmpty ?? true) ||
        (user?.isEmpty ?? true) ||
        (password?.isEmpty ?? true)) {
      MyDialog(context: context).normalDailog(
          title: 'Have Space', SubTitle: 'Pleade Fill Every Blank');
    } else if (typeUser == null) {
      MyDialog(context: context).normalDailog(
          title: 'No TypeUser', SubTitle: 'Please Choose TypeUser');
    } else {
      String urlGetUserWhereUser =
          'http://www.program2me.com/api/ungapi/getUserWhereUser.php?user=$user';
      await Dio().get(urlGetUserWhereUser).then((value) async {
        print('value ==> $value');

        if (value.toString() == 'null') {
          String urlInserUser =
              'http://www.program2me.com/api/ungapi/insertData.php?user=$user&password=$password&name=$name&usertype=$typeUser&lat=$lat&lng=$lng&token=$token';
          await Dio().get(urlInserUser).then((value) {
            if (value.toString() == 'true') {
              Navigator.pop(context);
            } else {
              MyDialog(context: context).normalDailog(
                  title: 'Something Error', SubTitle: 'Please Try again');
            }
          });
        } else {
          MyDialog(context: context).normalDailog(
              title: 'User False', SubTitle: 'Plaese Change User');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          ShowIconButton(
              iconData: Icons.cloud_upload_outlined,
              pressFunc: processCreateAccount)
        ],
        title: ShowText(
          label: 'Create New Account',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: ListView(
          children: [
            newCenter(
              widget: ShowForm(
                label: 'Name :',
                iconData: Icons.fingerprint,
                changeFunc: (String string) {
                  name = string.trim();
                },
              ),
            ),
            newCenter(widget: newTypeUser()),
            newCenter(
              widget: ShowForm(
                label: 'User',
                iconData: Icons.perm_identity,
                changeFunc: (String string) {
                  user = string.trim();
                },
              ),
            ),
            newCenter(
              widget: ShowForm(
                label: 'Password',
                iconData: Icons.lock_outline,
                changeFunc: (String string) {
                  password = string.trim();
                },
              ),
            ),
            newCenter(
              widget: newMap(),
            ),
            newCenter(
              widget: ShowBotton(
                label: 'Create New Account',
                pressFunc: processCreateAccount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container newMap() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(15)),
      width: 300,
      height: 300,
      child: lat == null
          ? const ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat!, lng!),
                zoom: 16,
              ),
              onMapCreated: (value) {},
              markers: mySetMarker(),
            ),
    );
  }

  Set<Marker> mySetMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'Your Location', snippet: 'lat = $lat,\n lng = $lng')),
    ].toSet();
  }

  Container newTypeUser() {
    return Container(
      padding: const EdgeInsets.only(left: 32),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
          border: Border.all(color: MyConstant.dark),
          borderRadius: BorderRadius.circular(15)),
      width: 250,
      height: 40,
      child: DropdownButton<dynamic>(
        underline: const SizedBox(),
        hint: const ShowText(label: 'Please Choose TypeUser'),
        value: typeUser,
        items: typeUsers
            .map(
              (e) => DropdownMenuItem(
                child: ShowText(label: e),
                value: e,
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            typeUser = value;
          });
        },
      ),
    );
  }

  Row newCenter({required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget,
      ],
    );
  }
}
