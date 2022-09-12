import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jezzyshopping/bodys/my_order_buyer.dart';
import 'package:jezzyshopping/bodys/shopping_mall_buyer.dart';
import 'package:jezzyshopping/bodys/show_cart.dart';
import 'package:jezzyshopping/models/user_model%20copy.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_menu.dart';
import 'package:jezzyshopping/widgets/show_sign_out.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  var titles = <String>[
    'Shopping',
    'My Order',
    'Cart',
  ];

  var bodys = <Widget>[
    const ShoppingMallBuyer(),
    const MyOrderBuyer(),
    const ShowCart(),
  ];

  var icons = <IconData>[
    Icons.shopping_bag,
    Icons.price_change,
    Icons.shopping_cart,
  ];
  int indexBody = 0;
  var bottomNaviIems = <BottomNavigationBarItem>[];

  FlutterLocalNotificationsPlugin flutterLocalNotiPlugin =
      FlutterLocalNotificationsPlugin();
  InitializationSettings? initializationSettings;
  AndroidInitializationSettings? androidInitializationSettings;
  IOSInitializationSettings? iosInitializationSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBottomNavItems();
    setupLocalNoti();
    processNotification();
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

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? keyUser = preferences.getString(MyConstant.keyUser);

    if (token != null) {
      print('token Buyer ==>> $token');
      await MyApi().processUpdateToken(code: keyUser!, token: token);
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

  void createBottomNavItems() {
    for (var i = 0; i < bodys.length; i++) {
      bottomNaviIems.add(BottomNavigationBarItem(
        label: titles[i],
        icon: Icon(
          icons[i],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      drawer: newDrawer(context),
      body: bodys[indexBody],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNaviIems,
        currentIndex: indexBody,
        onTap: (Value) {
          indexBody = Value;
          setState(() {});
        },
      ),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      centerTitle: true,
      foregroundColor: MyConstant.dark,
      flexibleSpace: Container(
        decoration: MyConstant().mainAppBar(),
      ),
      title: ShowText(
        label: titles[indexBody],
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

  Drawer newDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: MyConstant().mainBG(),
            accountName: null,
            accountEmail: null,
          ),
          ShowMenu(
            iconData: icons[0],
            title: titles[0],
            subTitle: 'ร้านค้าและสินค้า',
            pressFunc: () {
              Navigator.pop(context);
              indexBody = 0;
              setState(() {});
            },
          ),
          Divider(color: MyConstant.dark),
          ShowMenu(
            iconData: icons[1],
            title: titles[1],
            subTitle: 'รายการสั่งซื้อ',
            pressFunc: () {
              Navigator.pop(context);
              indexBody = 1;
              setState(() {});
            },
          ),
          Divider(color: MyConstant.dark),
          ShowMenu(
            iconData: icons[2],
            title: titles[2],
            subTitle: 'ตระกร้าสินค้า',
            pressFunc: () {
              Navigator.pop(context);
              indexBody = 0;
              setState(() {});
            },
          ),
          Divider(color: MyConstant.dark),
          const Spacer(),
          Divider(color: MyConstant.dark),
          ShowSignOut()
        ],
      ),
    );
  }
}
