import 'package:flutter/material.dart';
import 'package:jezzyshopping/bodys/my_order_buyer.dart';
import 'package:jezzyshopping/bodys/shopping_mall_buyer.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_menu.dart';
import 'package:jezzyshopping/widgets/show_sign_out.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  var titles = <String>[
    'Shopping Mall',
    'My Order',
  ];

  var bodys = <Widget>[
    const ShoppingMallBuyer(),
    const MyOrderBuyer(),
  ];

  int indexBody = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: MyConstant.dark,
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
        title: ShowText(
          label: titles[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
      ),
      drawer: newDrawer(context),
      body: bodys[indexBody],
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
            iconData: Icons.shopping_cart,
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
            iconData: Icons.menu_open,
            title: titles[1],
            subTitle: 'รายการสั่งซื้อ',
            pressFunc: () {
              Navigator.pop(context);
              indexBody = 1;
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
