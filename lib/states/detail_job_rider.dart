// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jezzyshopping/main.dart';

import 'package:jezzyshopping/models/order_model.dart';
import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/utility/my_api.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class DetailJobRider extends StatefulWidget {
  final OrderModel orderModel;
  final UserModel userModel;

  const DetailJobRider({
    Key? key,
    required this.orderModel,
    required this.userModel,
  }) : super(key: key);

  @override
  State<DetailJobRider> createState() => _DetailJobRiderState();
}

class _DetailJobRiderState extends State<DetailJobRider> {
  OrderModel? orderModel;
  UserModel? userModelRider, userModelBuyer, userModelShopper;
  double? lat, lng;

  Map<MarkerId, Marker> markerMap = {};
  BitmapDescriptor? bitMapBuyer, bitMapShopper;
  double? distanceShopUser, distanceRiderShop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderModel = widget.orderModel;
    userModelRider = widget.userModel;
    createBitMap();
    findModelBuyerShopper();
  }

  Future<void> createBitMap() async {
    bitMapBuyer = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'images/buyer.png');

    bitMapShopper = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'images/shopper.png');
  }

  Future<void> findModelBuyerShopper() async {
    userModelBuyer = await MyApi().findUserModel(user: orderModel!.codebuyer);
    userModelShopper =
        await MyApi().findUserModel(user: orderModel!.codeshoper);

    distanceShopUser = await MyCalulate().calculateDistance(
      double.parse(userModelShopper!.lat),
      double.parse(userModelShopper!.lng),
      double.parse(userModelBuyer!.lat),
      double.parse(userModelBuyer!.lng),
    );

    MarkerId buyerMarkerId = const MarkerId('buyer');
    Marker buyerMaker = Marker(
      markerId: buyerMarkerId,
      position: LatLng(
        double.parse(userModelBuyer!.lat),
        double.parse(userModelBuyer!.lng),
      ),
      infoWindow: const InfoWindow(title: 'Buyer'),
      icon: bitMapBuyer!,
    );

    MarkerId shopperMarkerId = const MarkerId('shopper');
    Marker shopperMarker = Marker(
      markerId: shopperMarkerId,
      position: LatLng(
        double.parse(userModelShopper!.lat),
        double.parse(userModelShopper!.lng),
      ),
      infoWindow: const InfoWindow(title: 'shopper'),
      icon: bitMapShopper!,
    );

    markerMap[buyerMarkerId] = buyerMaker;
    markerMap[shopperMarkerId] = shopperMarker;

    findPosition();
  }

  Future<void> findPosition() async {
    LocationPermission locationPermission;
    bool result = await Geolocator.isLocationServiceEnabled();

    if (result) {
      // True Open Location
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.deniedForever) {
        MyDialog(context: context).normalDailog(
          title: 'DeniedForever',
          SubTitle: 'Open Location',
          label: 'Open Location',
          pressFunc: () async {
            await Geolocator.openAppSettings();
          },
        );
      } else {
        if (locationPermission == LocationPermission.denied) {
          await Geolocator.requestPermission().then((value) {
            locationPermission = value;

            if ((locationPermission != LocationPermission.whileInUse) &&
                (locationPermission != LocationPermission.always)) {
              MyDialog(context: context).normalDailog(
                title: 'DeniedForever',
                SubTitle: 'Open Location',
                label: 'Open Location',
                pressFunc: () async {
                  await Geolocator.openAppSettings();
                },
              );
            } else {
              findLatLan();
            }
          });
        } else {
          await findLatLan();
        }
      }
    } else {
      // false Close Location
      MyDialog(context: context).normalDailog(
        title: 'Off Location',
        SubTitle: 'กรุณาเปิดโลเคชั่นก่อน',
        label: 'On Location',
        pressFunc: () async {
          await Geolocator.openAppSettings();
        },
      );
    }
  }

  Future<void> findLatLan() async {
    Position? position = await Geolocator.getCurrentPosition();

    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;

      print('lat = $lat, lng = $lng');

      distanceRiderShop = await MyCalulate().calculateDistance(
        lat!,
        lng!,
        double.parse(userModelShopper!.lat),
        double.parse(userModelShopper!.lng),
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: LayoutBuilder(
        builder: (p0, BoxConstraints boxConstraints) {
          return Column(
            children: [
              newMap(boxConstraints),
              newContent(),
              ShowBotton(
                  label: 'รับงาน',
                  pressFunc: () {
                    processTakeWork();
                  })
            ],
          );
        },
      ),
    );
  }

  Future<void> processTakeWork() async {
    String codeRider = userModelRider!.Code;
    var strings = <String>[];
    strings.add(codeRider);
    strings.add('rider');

    print('##26sep รับงาน ==>> $strings');

    String pathAPIeditStatus =
        'http://www.program2me.com/api/ungapi/myorder_updatestatus.php?id=${orderModel!.id}&status=${strings.toString()}';

    await Dio().get(pathAPIeditStatus).then((value) async {
      // Send to Buyer
      await MyApi().processSendNotification(
          token: userModelBuyer!.token,
          title: 'Rider รับงานแล้ว',
          body: 'Rider กำลังไปรับของที่ร้าน');

      // Setd to Shopper
      await MyApi()
          .processSendNotification(
              token: userModelShopper!.Code,
              title: 'ไรเดอร์กดรับงาน',
              body: 'Rider กำลังไปรับของที่ร้านคุณ')
          .then(
            (value) => Navigator.pop(context),
          );
    });
  }

  Container newContent() {
    return Container(
      margin: const EdgeInsets.only(left: 32),
      child: Column(
        children: [
          Row(
            children: [
              ShowText(
                label: 'Distance Shop ->> Buyer = ',
                textStyle: MyConstant().h2Style(),
              ),
              distanceShopUser == null
                  ? const SizedBox()
                  : ShowText(
                      label: MyCalulate()
                          .distanceFormat(distance: distanceShopUser!),
                      textStyle: MyConstant().h3ActiveStyle(),
                    ),
            ],
          ),
          Row(
            children: [
              ShowText(
                label: 'ค่าจัดส่ง : ',
                textStyle: MyConstant().h2Style(),
              ),
              distanceShopUser == null
                  ? const SizedBox()
                  : ShowText(
                      label:
                          ' ${MyConstant.factorDelivery} x ${distanceShopUser!.ceil()} = ${MyConstant.factorDelivery * distanceShopUser!.ceil()} THB',
                      textStyle: MyConstant().h3ActiveStyle(),
                    ),
            ],
          ),
          Row(
            children: [
              ShowText(
                label: 'ระยะห่างจากร้าน : ',
                textStyle: MyConstant().h2Style(),
              ),
              distanceRiderShop == null
                  ? const SizedBox()
                  : ShowText(
                      label: MyCalulate()
                          .distanceFormat(distance: distanceRiderShop!),
                      textStyle: MyConstant().h3ActiveStyle(),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Container newMap(BoxConstraints boxConstraints) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: lat == null
          ? const ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat!, lng!),
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markerMap.values),
            ),
      width: boxConstraints.maxWidth,
      height: boxConstraints.maxHeight * 0.6,
      decoration: BoxDecoration(border: Border.all()),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      title: ShowText(
        label: orderModel!.tdatetime!,
        textStyle: MyConstant().h2Style(),
      ),
      foregroundColor: MyConstant.dark,
      flexibleSpace: Container(
        decoration: MyConstant().mainAppBar(),
      ),
    );
  }
}
