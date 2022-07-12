// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  var files = <File?>[];

  bool change = false; // true ==>> Have change
  String? name, qty, unit, price;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    nameController.text = productModel!.name;
    qtyController.text = productModel!.qty;
    unitController.text = productModel!.unit;
    priceController.text = productModel!.price;

    name = productModel!.name;
    qty = productModel!.qty;
    unit = productModel!.unit;
    price = productModel!.price;

    urlImages =
        MyCalulate().changeStriongToArray(string: productModel!.picture);

    for (var i = 0; i < urlImages.length; i++) {
      files.add(null);
    }
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
            urlImages.length == 4 ? const SizedBox() : iconAddPicture(),
            const SizedBox(
              height: 16,
            ),
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
        pressFunc: () {
          if (change) {
            processUploadAdnEditData();
          } else {
            MyDialog(context: context).normalDailog(
                title: 'No Change', SubTitle: 'Please Edit Something');
          }
        },
      ),
    );
  }

  Future<void> processUploadAdnEditData() async {
    for (var i = 0; i < files.length; i++) {
      if (files[i] != null) {
        String nameFile = 'imageEdit${Random().nextInt(1000000)}.jpg';
        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(files[i]!.path, filename: nameFile);
        String pathApi = 'http://www.program2me.com/api/ungapi/saveProduct.php';

        FormData formData = FormData.fromMap(map);
        await Dio().post(pathApi, data: formData).then((value) async {
          String urlImage =
              'http://www.program2me.com/api/ungapi/product/$nameFile';
          urlImages[i] = urlImage;
        });
      }
    }

    String pathApiEditProduct =
        'http://www.program2me.com/api/ungapi/ProductEditWhereId.php?id=${productModel!.id}&name=$name&unit=$unit&price=$price&qty=$qty&picture=${urlImages.toString()}';
    await Dio().get(pathApiEditProduct).then((value) {
      Navigator.pop(context);
    });
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
            pressFunc: () {
              MyDialog(context: context).normalDailog(
                  label: 'Camera',
                  pressFunc: () {
                    Navigator.pop(context);
                    processAddMorePicture(source: ImageSource.camera);
                  },
                  label2: 'Gallerty',
                  pressFunc2: () {
                    Navigator.pop(context);
                    processAddMorePicture(source: ImageSource.gallery);
                  },
                  title: 'Soure Image',
                  SubTitle: 'Please Tap Camera or Gallery');
            },
          ),
        ],
      ),
    ));
  }

  Future<void> processAddMorePicture({required ImageSource source}) async {
    change = true;
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (result != null) {
      urlImages.add('');
      files.add(null);
      int index = files.length - 1;
      files[index] = File(result.path);
      setState(() {});
    }
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
                  child: files[index] == null
                      ? Image.network(
                          urlImages[index],
                        )
                      : Image.file(files[index]!),
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
                        pressFunc: () {
                          MyDialog(context: context).normalDailog(
                              label: 'Camera',
                              pressFunc: () {
                                Navigator.pop(context);
                                processTakePhoto(
                                    source: ImageSource.camera, index: index);
                              },
                              label2: 'Galerry',
                              pressFunc2: () {
                                Navigator.pop(context);
                                processTakePhoto(
                                    source: ImageSource.gallery, index: index);
                              },
                              title: 'Source Image?',
                              SubTitle: 'Please Tap Camera Or Gallery');
                        },
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
                                      change = true;
                                      Navigator.pop(context);
                                      print(
                                          'urlImages Before delete ==>> $urlImages');
                                      print('delete image index ==>> $index');

                                      urlImages.removeAt(index);
                                      files.removeAt(index);

                                      print(
                                          'urlImages After delete ==>> $urlImages');

                                      setState(() {});
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
        changeFunc: (String string) {
          price = string.trim();
          change = true;
        },
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
              changeFunc: (String string) {
                qty = string.trim();
                change = true;
              },
            ),
            ShowForm(
              textEditingController: unitController,
              width: 120,
              label: 'Unit',
              iconData: Icons.ac_unit,
              changeFunc: (String string) {
                unit = string.trim();
                change = true;
              },
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
      changeFunc: (String string) {
        name = string.trim();
        change = true;
      },
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

  Future<void> processTakePhoto(
      {required ImageSource source, required int index}) async {
    change = true;
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    files[index] = File(result!.path);
    setState(() {});
  }
}
