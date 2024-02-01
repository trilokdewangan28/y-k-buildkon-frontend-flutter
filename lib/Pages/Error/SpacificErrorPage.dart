
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/Constant.dart';

class SpacificErrorPage extends StatefulWidget {

  const SpacificErrorPage({Key? key})
      : super(key: key);

  @override
  _SpacificErrorPageState createState() => _SpacificErrorPageState();
}

class _SpacificErrorPageState extends State<SpacificErrorPage> {
  bool knowMore = false;
  String btncontent = "know more";
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
            SizedBox(height: MediaQuery.of(context).size.height*0.2),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //==========================500 text
                const Text(
                  '500',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                  ),
                ),
                const SizedBox(height: 20,),

                //===========================internal server error text
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Internal Server Error',
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: MyConst.extraLargeTextSize*fontSizeScaleFactor
                    ),
                  ),
                ),
                const SizedBox(height: 15,),

                //========================== error message text
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    appState.errorString,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: MyConst.mediumSmallTextSize*fontSizeScaleFactor
                    ),
                  ),
                ),

                //========================== suggestion message
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'please refresh the page and try again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: MyConst.mediumSmallTextSize*fontSizeScaleFactor
                    ),
                  ),
                ),


                //==========================know more button text
                appState.error.isNotEmpty
                    ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        knowMore=!knowMore;
                      });
                    },
                    child: knowMore ==false ? const Text(
                      'know more'
                    ) : const Text('know less'),
                  ),
                )
                    :Container(),

                knowMore==true
                    ? Center(child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    appState.error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: MyConst.smallTextSize*fontSizeScaleFactor
                    ),
                  ),
                ),)
                    : Container(),

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
        appState.activeWidget = appState.fromWidget;
        setState(() {

        });
      },
    );
  }
}

