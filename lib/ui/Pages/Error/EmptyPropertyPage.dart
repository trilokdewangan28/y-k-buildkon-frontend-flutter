import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/Constant.dart';
class EmptyPropertyPage extends StatelessWidget {
  final String text;
  final String backWidget;
  const EmptyPropertyPage({Key? key, required this.text, required this.backWidget}) : super(key: key);

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
