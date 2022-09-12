import 'dart:ui';

import 'package:flutter/material.dart';

class MyConstant {
  static var urlBanners = <String>[
    'http://www.program2me.com/api/ungapi/banner/banner1.png',
    'http://www.program2me.com/api/ungapi/banner/banner2.png',
    'http://www.program2me.com/api/ungapi/banner/banner3.png',
  ];

  static var typeUsers = <String>[
    'Buyer',
    'Shopper',
    'Rider',
  ];

  static String urlPromptpay =
      'http://www.program2me.com/api/ungapi/images/promtpay0634932824.png';

  static String keyUser = 'user';
  static String keyTypeUser = 'typeUser';

  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createaccount';
  static String routeBuyer = '/buyerService';
  static String routeShopper = '/shopperService';
  static String routeRider = '/riderService';

  static Color primary = const Color(0xffadd500);
  static Color dark = const Color(0xff133c29);
  static Color light = Color.fromARGB(240, 240, 255, 174);

  BoxDecoration mainAppBar() => BoxDecoration(
          gradient: LinearGradient(
        colors: <Color>[MyConstant.light, MyConstant.primary],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ));

  BoxDecoration mainBG() => BoxDecoration(
        gradient: RadialGradient(
            colors: <Color>[Colors.white, MyConstant.primary],
            radius: 1,
            center: Alignment(-0.4, -0.4)),
      );

  TextStyle h1Style() => TextStyle(
        color: dark,
        fontSize: 48,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        color: dark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
  TextStyle h3Style() => TextStyle(
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
  TextStyle h3GreenStyle() => const TextStyle(
        color: Colors.green,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
  TextStyle h3ActiveStyle() => const TextStyle(
        color: Colors.pink,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );
}
