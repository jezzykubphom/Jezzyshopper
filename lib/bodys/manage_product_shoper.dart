import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/states/add_product_shoper.dart';
import 'package:jezzyshopping/states/edit_product_shoper.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProductShoper extends StatefulWidget {
  const ManageProductShoper({Key? key}) : super(key: key);

  @override
  State<ManageProductShoper> createState() => _ManageProductShoperState();
}

class _ManageProductShoperState extends State<ManageProductShoper> {
  String? shopCode;
  bool load = true;
  bool? haveData;
  var productModels = <ProductModel>[];
  var listUrlImages = <List<String>>[];

  @override
  void initState() {
    super.initState();
    readMyPorduct();
  }

  Future<void> readMyPorduct() async {
    if (productModels.isNotEmpty) {
      productModels.clear();
      listUrlImages.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopCode = preferences.getString(MyConstant.keyUser);

    String pathGetProduct =
        'http://www.program2me.com/api/ungapi/getAllProduct.php?shopcode=$shopCode';
    await Dio().get(pathGetProduct).then((value) {
      print('value get ProdcutAll ==> $value');

      if (value.toString() == 'null') {
        haveData = false;
      } else {
        haveData = true;

        for (var element in value.data) {
          ProductModel productModel = ProductModel.fromMap(element);
          productModels.add(productModel);

          var urlImages =
              MyCalulate().changeStriongToArray(string: productModel.picture);
          print('urlImage ==>> $urlImages');
          listUrlImages.add(urlImages);
        }
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      return SizedBox(
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        child: Stack(
          children: [
            load
                ? const ShowProgress()
                : haveData!
                    ? SizedBox(
                        width: boxConstraints.maxWidth,
                        height: boxConstraints.maxHeight - 66,
                        child: listProduct(boxConstraints),
                      )
                    : ShowText(
                        label: 'No Product',
                        textStyle: MyConstant().h1Style(),
                      ),
            Positioned(
              bottom: 0,
              child: buttonAddProduct(boxConstraints: boxConstraints),
            ),
          ],
        ),
      );
    });
  }

  ListView listProduct(BoxConstraints boxConstraints) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            SizedBox(
              width: boxConstraints.maxWidth * 0.5 - 4,
              height: boxConstraints.maxWidth * 0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Image.network(
                  listUrlImages[index][0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: boxConstraints.maxWidth * 0.5 - 4,
              height: boxConstraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowText(
                    label: productModels[index].name,
                    textStyle: MyConstant().h2Style(),
                  ),
                  ShowText(
                      label:
                          'Price : ${productModels[index].price} THB/${productModels[index].unit}'),
                  ShowText(
                      label:
                          'Qty : ${productModels[index].qty} ${productModels[index].unit}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShowIconButton(
                        color: const Color.fromARGB(255, 7, 185, 13),
                        iconData: Icons.edit_off_outlined,
                        pressFunc: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductShoper(
                                    productModel: productModels[index]),
                              )).then((value) => null);
                        },
                      ),
                      ShowIconButton(
                        color: const Color.fromARGB(255, 244, 24, 9),
                        iconData: Icons.delete_forever_outlined,
                        pressFunc: () {
                          MyDialog(context: context).normalDailog(
                              label: 'Confirm Del',
                              pressFunc: () async {
                                Navigator.pop(context);

                                print('Del ID ==>> ${productModels[index].id}');
                                String pathDeleteProduct =
                                    'http://www.program2me.com/api/ungapi/productDeleteWhereId.php?id=${productModels[index].id}';
                                await Dio()
                                    .get(pathDeleteProduct)
                                    .then((value) {
                                  load = true;
                                  readMyPorduct();
                                  setState(() {});
                                });
                              },
                              label2: 'Cacel',
                              pressFunc2: () {
                                Navigator.pop(context);
                              },
                              title: 'Confirm Delete?',
                              SubTitle:
                                  'Are you sure delete ${productModels[index].name}');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buttonAddProduct({required BoxConstraints boxConstraints}) {
    return SizedBox(
      width: boxConstraints.maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowBotton(
            label: 'Add New Product',
            pressFunc: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductShoper(shopCode: shopCode!),
                ),
              ).then((value) {
                load = true;
                readMyPorduct();
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }
}
