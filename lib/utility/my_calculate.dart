import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCalulate {
  Future<String?> processFindMyPinCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString('pincode');
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Future<Position> findCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  String moneyFormat({required int money}) {
    String moneyForm = '';
    NumberFormat numberFormat = NumberFormat('#,###', 'en_US');
    moneyForm = numberFormat.format(money);
    return moneyForm;
  }

  String distanceFormat({required double distance}) {
    String distanceForm = '';
    NumberFormat numberFormat = NumberFormat('##0.0#', 'en_US');
    distanceForm = numberFormat.format(distance);
    distanceForm = '$distanceForm KM';
    return distanceForm;
  }

  int calulateTotal({required List<String> sums}) {
    int total = 0;

    for (var element in sums) {
      total = total + int.parse(element.trim());
    }
    return total;
  }

  String cutWord({required String string, int? number}) {
    String word = string;
    int numWord = number ?? 9;

    if (word.length > numWord) {
      word = word.substring(0, number);
      word = '$word...';
    }
    return word;
  }

  List<String> changeStriongToArray({required String string}) {
    var results = <String>[];

    String myString = string.substring(1, string.length - 1);
    results = myString.split(',');
    for (var i = 0; i < results.length; i++) {
      results[i] = results[i].trim();
    }

    return results;
  }
}
