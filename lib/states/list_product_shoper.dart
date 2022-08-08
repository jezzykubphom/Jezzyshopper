// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jezzyshopping/models/product_model.dart';

import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/states/detail_product.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/widgets/show_progress.dart';
import 'package:jezzyshopping/widgets/show_text.dart';
import 'package:jezzyshopping/widgets/shwo_imag_internet.dart';

class ListProductShoper extends StatefulWidget {
  final UserModel userShopModel;
  const ListProductShoper({
    Key? key,
    required this.userShopModel,
  }) : super(key: key);

  @override
  State<ListProductShoper> createState() => _ListProductShoperState();
}

class _ListProductShoperState extends State<ListProductShoper> {
  UserModel? userShopModel;
  bool load = true;
  bool? haveProduct;
  var productModels = <ProductModel>[];
  var listPictures = <List<String>>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userShopModel = widget.userShopModel;
    readProduct();
  }

  Future<void> readProduct() async {
    String shopcode = userShopModel!.Code;
    //print('Shopcode ==>> $shopcode');

    String path =
        'http://www.program2me.com/api/ungapi/getAllProduct.php?shopcode=$shopcode';

    await Dio().get(path).then((value) {
      if (value.toString() == 'null') {
        haveProduct = false;
      } else {
        haveProduct = true;

        for (var element in value.data) {
          ProductModel productModel = ProductModel.fromMap(element);
          productModels.add(productModel);

          var pictures =
              MyCalulate().changeStriongToArray(string: productModel.picture);
          listPictures.add(pictures);
        }
      }

      load = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => load
            ? const ShowProgress()
            : haveProduct!
                ? listProduct(constraints)
                : Center(
                    child: ShowText(
                      label: 'No prouct',
                      textStyle: MyConstant().h1Style(),
                    ),
                  ),
      ),
    );
  }

  ListView listProduct(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetialProduct(productModel: productModels[index]),
              ));
        },
        child: Card(
          child: Row(
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.4 - 4,
                height: constraints.maxWidth * 0.4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ShowImageInternet(
                    path: listPictures[index][0],
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.6 - 4,
                height: constraints.maxWidth * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowText(
                      label: productModels[index].name,
                      textStyle: MyConstant().h2Style(),
                    ),
                    ShowText(label: 'ราคา ${productModels[index].price} บาท'),
                    ShowText(
                        label:
                            'จำนวน ${productModels[index].qty} ${productModels[index].unit}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      centerTitle: true,
      title: ShowText(
        label: userShopModel!.Name,
        textStyle: MyConstant().h2Style(),
      ),
      foregroundColor: MyConstant.dark,
      flexibleSpace: Container(
        decoration: MyConstant().mainAppBar(),
      ),
    );
  }
}
