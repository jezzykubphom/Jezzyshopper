// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jezzyshopping/bodys/information_shoper.dart';
import 'package:jezzyshopping/bodys/order_shoper.dart';
import 'package:jezzyshopping/bodys/setting_pincode.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/Show_image_avatar.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_menu.dart';
import 'package:jezzyshopping/widgets/show_sign_out.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/shwo_imag_internet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bodys/manage_product_shoper.dart';

class ShopperService extends StatefulWidget {
  const ShopperService({Key? key}) : super(key: key);

  @override
  State<ShopperService> createState() => _ShopperServiceState();
}

class _ShopperServiceState extends State<ShopperService> {
  UserModel? userModel;
  var bodys = <Widget>[
    const OrderShoper(),
    const InformationShoper(),
    const ManageProductShoper(),
    const SettingPincode(),
  ];

  var titles = <String>[
    'My Order',
    'Information',
    'Manage Product',
    'PinCode',
  ];

  int indexBody = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FlutterLocalNotificationsPlugin flutterLocalNotiPlugin =
      FlutterLocalNotificationsPlugin();
  InitializationSettings? initializationSettings;
  AndroidInitializationSettings? androidInitializationSettings;
  IOSInitializationSettings? iosInitializationSettings;

  @override
  void initState() {
    super.initState();
    processFindUserModel();
    setupLocalNoti();
  }

  Future<void> setupLocalNoti() async {
    androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');

    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNoti);

    initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotiPlugin.initialize(
      initializationSettings!,
      onSelectNotification: onSelectNoti,
    );
  }

  Future onDidReceiveLocalNoti(
      int id, String? title, String? body, String? string) async {
    return CupertinoAlertDialog(
      title: ShowText(
        label: title!,
        textStyle: MyConstant().h2Style(),
      ),
      content: ShowText(label: body!),
      actions: [
        CupertinoDialogAction(
          child: ShowText(label: 'OK'),
          onPressed: () {},
        ),
      ],
    );
  }

  Future<void> onSelectNoti(String? string) async {
    if (string != null) {
      print('String ==> $string');
    }
  }

  Future<void> processShowLocalNoti(
      {required String title, required String body}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channelId',
      'channelName',
      priority: Priority.high,
      importance: Importance.max,
      ticker: 'Jed Mall',
    );

    IOSNotificationDetails iosNotificationDetails =
        const IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotiPlugin.show(0, title, body, notificationDetails);
  }

  Future<void> processNotification() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();

    if (token != null) {
      print('token ==>> $token');
      await MyApi().processUpdateToken(code: userModel!.Code, token: token);
    }

    // Open APP
    FirebaseMessaging.onMessage.listen((event) {
      String title = event.notification!.title!;
      String body = event.notification!.body!;

      print('Notification Open APP ==>> titel : $title, Body : $body');
      processShowLocalNoti(title: title, body: body);
    });

    // Close APP
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String title = event.notification!.title!;
      String body = event.notification!.body!;

      print('Notification Close APP ==>> titel : $title, Body : $body');
      processShowLocalNoti(title: title, body: body);
    });
  }

  Future<void> processFindUserModel() async {
    print('processFindUserModel work');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString(MyConstant.keyUser);

    // print('user ==> $user');

    userModel = await MyApi().findUserModel(user: user!);

    if (userModel != null) {
      // print('userModel ==> ${userModel!.toMap()}');
      processNotification();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: ShowIconButton(
          iconData: Icons.menu,
          pressFunc: () {
            processFindUserModel();
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: ShowText(
          label: titles[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
        foregroundColor: MyConstant.dark,
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
      drawer: newDrawer(),
      body: bodys[indexBody],
    );
  }

  Drawer newDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            newHeadDrawer(),
            ShowMenu(
              iconData: Icons.shopping_bag_outlined,
              title: 'MyOrder',
              pressFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexBody = 0;
                });
              },
              subTitle: 'Order Wait Approve or Cancel',
            ),
            Divider(color: MyConstant.dark),
            ShowMenu(
              iconData: Icons.shop_2,
              title: 'Information',
              pressFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexBody = 1;
                });
              },
              subTitle: 'Details Shop',
            ),
            Divider(color: MyConstant.dark),
            ShowMenu(
              iconData: Icons.manage_search,
              title: titles[2],
              pressFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexBody = 2;
                });
              },
              subTitle: 'Manage Product',
            ),
            Divider(color: MyConstant.dark),
            ShowMenu(
              iconData: Icons.pin,
              title: titles[3],
              pressFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexBody = 3;
                });
              },
              subTitle: 'Setting Pincode',
            ),
            Divider(color: MyConstant.dark),
            const ShowSignOut(),
          ],
        ),
      ),
    );
  }

  UserAccountsDrawerHeader newHeadDrawer() => UserAccountsDrawerHeader(
        currentAccountPicture: userModel == null
            ? const SizedBox()
            : SizedBox(
                width: 80,
                height: 80,
                child: ShowImageAvatar(path: userModel!.Picture)),
        decoration: BoxDecoration(color: MyConstant.light),
        accountName: userModel == null
            ? ShowText(
                label: 'name = ?',
                textStyle: MyConstant().h2Style(),
              )
            : ShowText(
                label: userModel!.Name,
                textStyle: MyConstant().h2Style(),
              ),
        accountEmail: const ShowText(label: 'Shoper'),
      );
}
