import 'package:dio/dio.dart';
import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/models/user_model.dart';

class MyApi {
  Future<void> updateLatLng(
      {required String code, required double lat, required double lng}) async {
    String path =
        'http://www.program2me.com/api/ungapi/editUserLocationWhereCode.php?Code=$code&lat=$lat&lng=$lng';

    await Dio().get(path).then((value) => print('update LatLng Success'));
  }

  Future<void> processSendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    String urlAPI =
        'http://www.program2me.com/api/ungapi/ungJadNoti.php?isAdd=true&token=$token&title=$title&body=$body';

    await Dio().get(urlAPI).then((value) {
      print('Send Notification Success');
    });
  }

  Future<void> processUpdateToken(
      {required String code, required String token}) async {
    String urlAPI =
        'http://www.program2me.com/api/ungapi/userUpdateToken.php?code=$code&token=$token';
    await Dio().get(urlAPI).then((value) {
      print('UpdateToken Success');
    });
  }

  Future<ProductModel?> fideProductModel({required String idProduct}) async {
    String path =
        'http://www.program2me.com/api/ungapi/getAllProductWhereId.php?id=$idProduct';

    var result = await Dio().get(path);
    // print('result findproductModel ==>> $result');

    for (var element in result.data) {
      ProductModel productModel = ProductModel.fromMap(element);
      //print('productModel ==>> ${productModel.toMap()}');
      return productModel;
    }

    return null;
  }

  Future<UserModel?> findUserModel({required String user}) async {
    String path =
        'http://www.program2me.com/api/ungapi/getUserWhereUser.php?user=$user';
    var result = await Dio().get(path);

    for (var element in result.data) {
      UserModel userModel = UserModel.fromMap(element);
      return userModel;
    }
    return null;
  }
}
