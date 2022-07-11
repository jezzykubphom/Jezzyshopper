// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jezzyshopping/models/product_model.dart';
import 'package:jezzyshopping/utility/my_calculate.dart';
import 'package:jezzyshopping/utility/my_constant.dart';
import 'package:jezzyshopping/utility/my_dialog.dart';
import 'package:jezzyshopping/widgets/show_button.dart';
import 'package:jezzyshopping/widgets/show_form.dart';
import 'package:jezzyshopping/widgets/show_icon_button.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class EditProductShoper extends StatefulWidget {
  final ProductModel productModel;

  const EditProductShoper({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  State<EditProductShoper> createState() => _EditProductShoperState();
}

class _EditProductShoperState extends State<EditProductShoper> {
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var urlImages = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    nameController.text = productModel!.name;
    qtyController.text = productModel!.qty;
    unitController.text = productModel!.unit;
    priceController.text = productModel!.price;

    urlImages =
        MyCalulate().changeStriongToArray(string: productModel!.picture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
        return ListView(
          children: [
            formName(),
            formQtyUnit(),
            formPrice(),
            const SizedBox(
              height: 16,
            ),
            listImage(boxConstraints),
            iconAddPicture(),
            bottomEditProduct(),
            const SizedBox(
              height: 16,
            ),
          ],
        );
      }),
    );
  }

  Row bottomEditProduct() {
    return createCenter(
      widget: ShowBotton(
        label: 'Edit Product',
        pressFunc: () {},
      ),
    );
  }

  Row iconAddPicture() {
    return createCenter(
        widget: SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShowIconButton(
            size: 48,
            color: Color.fromARGB(255, 14, 137, 237),
            iconData: Icons.add_a_photo,
            pressFunc: () {},
          ),
        ],
      ),
    ));
  }

  ListView listImage(BoxConstraints boxConstraints) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: urlImages.length,
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: boxConstraints.maxWidth * 0.75,
            height: boxConstraints.maxWidth * 0.75,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * 0.75,
                  height: boxConstraints.maxWidth * 0.75,
                  child: Image.network(
                    urlImages[index],
                  ),
                ),
                Container(
                  width: boxConstraints.maxWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                  ),
                  child: Row(
                    children: [
                      ShowIconButton(
                        color: Color.fromARGB(255, 1, 157, 6),
                        iconData: Icons.edit_outlined,
                        pressFunc: () {},
                      ),
                      urlImages.length == 1
                          ? const SizedBox()
                          : ShowIconButton(
                              color: Color.fromARGB(255, 223, 32, 18),
                              iconData: Icons.delete_forever,
                              pressFunc: () {
                                MyDialog(context: context).normalDailog(
                                    label2: 'Cancel',
                                    pressFunc2: () {
                                      Navigator.pop(context);
                                    },
                                    label: 'Confirm',
                                    pressFunc: () {
                                      Navigator.pop(context);
                                      print(
                                          'urlImages Before delete ==>> $urlImages');
                                      print('delete image index ==>> $index');

                                      urlImages.removeAt(index);

                                      print(
                                          'urlImages After delete ==>> $urlImages');
                                    },
                                    title: 'Confirm Del?',
                                    SubTitle: 'Are you sure delete?');
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row formPrice() {
    return createCenter(
      widget: ShowForm(
        textEditingController: priceController,
        label: 'Price',
        iconData: Icons.money,
        changeFunc: (String string) {},
      ),
    );
  }

  Row formQtyUnit() {
    return createCenter(
      widget: SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShowForm(
              textEditingController: qtyController,
              width: 120,
              label: 'Qty',
              iconData: Icons.android,
              changeFunc: (String string) {},
            ),
            ShowForm(
              textEditingController: unitController,
              width: 120,
              label: 'Unit',
              iconData: Icons.ac_unit,
              changeFunc: (String string) {},
            ),
          ],
        ),
      ),
    );
  }

  Row formName() {
    return createCenter(
        widget: ShowForm(
      textEditingController: nameController,
      label: 'Name',
      iconData: Icons.fingerprint,
      changeFunc: (String string) {},
    ));
  }

  Row createCenter({required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget,
      ],
    );
  }

  AppBar newAppBar() {
    return AppBar(
      title: ShowText(
        label: 'Edit Product',
        textStyle: MyConstant().h2Style(),
      ),
      foregroundColor: MyConstant.dark,
      flexibleSpace: Container(
        decoration: MyConstant().mainAppBar(),
      ),
    );
  }
}
