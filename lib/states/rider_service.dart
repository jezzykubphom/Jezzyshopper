import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jezzyshopping/bodys/current_job_rider.dart';
import 'package:jezzyshopping/bodys/list_job_rider.dart';
import 'package:jezzyshopping/main.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_menu.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_sign_out.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderService extends StatefulWidget {
  const RiderService({Key? key}) : super(key: key);

  @override
  State<RiderService> createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  var bodys = <Widget>[];
  var titles = <String>['List Job', 'Currnet Job'];
  var subTitles = <String>['รายละเอียดงาน'];
  int indexBody = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotiPlugin =
      FlutterLocalNotificationsPlugin();
  InitializationSettings? initializationSettings;
  AndroidInitializationSettings? androidInitializationSettings;
  IOSInitializationSettings? iosInitializationSettings;

  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processFindUserModel();
    setupLocalNoti();
  }

  Future<void> processFindUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? keyUser = preferences.getString(MyConstant.keyUser);

    userModel = await MyApi().findUserModel(user: keyUser!);

    bodys.add(ListJobRider(userModel: userModel!));
    bodys.add(CurrentJobRider(userModelRider: userModel!));
    setState(() {});

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

    if (token != null) {
      print('token Rider ==>> $token');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: MyConstant.dark,
        title: ShowText(
          label: titles[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            newHeadDrawer(),
            ShowMenu(
              iconData: Icons.motorcycle,
              title: titles[0],
              subTitle: subTitles[0],
              pressFunc: () {
                indexBody = 0;
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            Divider(
              color: MyConstant.dark,
            ),
            ShowMenu(
              iconData: Icons.work_outline,
              title: 'Current Job',
              subTitle: 'งานที่กำลังส่ง',
              pressFunc: () {
                indexBody = 1;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            const ShowSignOut()
          ],
        ),
      ),
      body: bodys.isEmpty ? const ShowProgress() : bodys[indexBody],
    );
  }

  UserAccountsDrawerHeader newHeadDrawer() {
    return UserAccountsDrawerHeader(
      decoration: MyConstant().mainBG(),
      accountName: null,
      accountEmail: null,
    );
  }
}
