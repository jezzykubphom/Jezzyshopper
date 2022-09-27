// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:jezzyshopping/models/order_model.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/states/detail_job_rider.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class ListJobRider extends StatefulWidget {
  final UserModel userModel;

  const ListJobRider({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ListJobRider> createState() => _ListJobRiderState();
}

class _ListJobRiderState extends State<ListJobRider> {
  bool load = true;
  bool? haveData;
  var orderModels = <OrderModel>[];
  UserModel? userModelRider;
  bool canReceiveJob = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModelRider = widget.userModel;
    checkCurrentJob();
    readOrder();
  }

  Future<void> checkCurrentJob() async {
    var strings = <String>[];
    strings.add(userModelRider!.Code);
    strings.add('rider');

    String apiRider =
        'http://www.program2me.com/api/ungapi/myorder_getstatus.php?status=${strings.toString()}';

    await Dio().get(apiRider).then((value) {
      if (value.toString() != 'null') {
        canReceiveJob = false;
      }
    });

    strings[1] = 'delivery';

    String apiDelivery =
        'http://www.program2me.com/api/ungapi/myorder_getstatus.php?status=${strings.toString()}';
    await Dio().get(apiDelivery).then((value) {
      if (value.toString() != 'null') {
        canReceiveJob = false;
      }
    });
  }

  Future<void> readOrder() async {
    if (orderModels.isNotEmpty) {
      load = true;
      orderModels.clear();
    }

    String path =
        'http://www.program2me.com/api/ungapi/myorder_getstatus.php?status=receive';
    await Dio().get(path).then((value) {
      if (value.data.toString() == 'null') {
        haveData = false;
      } else {
        haveData = true;

        for (var element in value.data) {
          OrderModel orderModel = OrderModel.fromMap(element);
          orderModels.add(orderModel);
        }
      }

      load = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveData!
            ? ListView.builder(
                itemCount: orderModels.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    if (canReceiveJob) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailJobRider(
                                orderModel: orderModels[index],
                                userModel: widget.userModel),
                          )).then((value) {
                        readOrder();
                      });
                    } else {
                      MyDialog(context: context).normalDailog(
                          title: 'ไม่สามารถรับงานได้',
                          SubTitle: 'คุณยังมีงานค้างส่งอยู่');
                    }
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowText(
                        label: orderModels[index].tdatetime!,
                        textStyle: MyConstant().h2Style(),
                      ),
                    ),
                  ),
                ),
              )
            : ShowText(
                label: 'No Job',
                textStyle: MyConstant().h2Style(),
              );
  }
}
