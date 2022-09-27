// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jezzyshopping/models/user_model.dart';
import 'package:jezzyshopping/widgets/show_text.dart';

class CurrentJobRider extends StatefulWidget {
  final UserModel userModelRider;

  const CurrentJobRider({
    Key? key,
    required this.userModelRider,
  }) : super(key: key);

  @override
  State<CurrentJobRider> createState() => _CurrentJobRiderState();
}

class _CurrentJobRiderState extends State<CurrentJobRider> {
  UserModel? userModelRider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModelRider = widget.userModelRider;
  }

  @override
  Widget build(BuildContext context) {
    return ShowText(label: userModelRider!.Name);
  }
}
