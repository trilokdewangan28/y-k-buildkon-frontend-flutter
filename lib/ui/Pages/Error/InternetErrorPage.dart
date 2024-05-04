import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/Constant.dart';

class InternetErrorPage extends StatelessWidget {
  const InternetErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
          appState.activeWidget = "LoginWidget";
          appState.currentState=1;
      },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Internet Error Page'),
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0.0,
          ),
          body: Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Center(child: Text(''
                    'Internet connection error'),),

                const SizedBox(
                  height: 200,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child:ElevatedButton(onPressed: (){
                      appState.activeWidget = "LoginWidget";
                      appState.currentState = 1;
                    }, child:const Text('BACK TO HOME')))
              ],
            ),
          ),
        )
    );
  }
}
