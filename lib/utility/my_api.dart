import 'package:dio/dio.dart';
import 'package:jezzyshopping/models/user_model.dart';

class MyApi {
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
