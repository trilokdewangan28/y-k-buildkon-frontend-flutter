import 'package:flutter/material.dart';
import 'package:real_state/config/Constant.dart';
class EmptyPropertyPage extends StatelessWidget {
  final String text;
  const EmptyPropertyPage({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text(text),
      ),
    );
  }
}
