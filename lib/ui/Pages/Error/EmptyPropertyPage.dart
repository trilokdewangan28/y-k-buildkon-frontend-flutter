import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
class EmptyPropertyPage extends StatelessWidget {
  final String text;
  final String backWidget;
  const EmptyPropertyPage({super.key, required this.text, required this.backWidget});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          appState.activeWidget = backWidget;
        },
        child: Container(
          color: Theme.of(context).primaryColorLight,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: MyConst.extraLargeTextSize*fontSizeScaleFactor,fontWeight: FontWeight.w500),
            ),
          ),
        )
    );
  }
}
