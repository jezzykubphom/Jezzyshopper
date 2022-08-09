import 'package:dio/dio.dart';
import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/models/user_model.dart';

class MyApi {
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
