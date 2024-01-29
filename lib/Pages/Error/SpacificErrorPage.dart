
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/Constant.dart';

class SpacificErrorPage extends StatefulWidget {
  final String fromWidget;
  final String errorString;

  const SpacificErrorPage({Key? key, required this.errorString, required this.fromWidget})
      : super(key: key);

  @override
  _SpacificErrorPageState createState() => _SpacificErrorPageState();
}

class _SpacificErrorPageState extends State<SpacificErrorPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return RefreshIndicator(
      child: Container(
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.4),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    widget.errorString,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
      onRefresh: () async {
        appState.activeWidget = widget.fromWidget;
        setState(() {

        });
      },
    );
  }
}

