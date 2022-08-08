// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ShowBanner extends StatelessWidget {
  final List<String> urlBanners;
  const ShowBanner({
    Key? key,
    required this.urlBanners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var element in urlBanners) {
      children.add(Image.network(element));
    }

    return ImageSlideshow(children: children);
  }
}
