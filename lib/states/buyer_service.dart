import 'package:flutter/material.dart';
import 'package:jezzyshopping/bodys/my_order_buyer.dart';
import 'package:jezzyshopping/bodys/shopping_mall_buyer.dart';
import 'package:jezzyshopping/bodys/show_cart.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBottomNavItems();
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
