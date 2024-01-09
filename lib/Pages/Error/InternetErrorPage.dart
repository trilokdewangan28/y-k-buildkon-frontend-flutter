import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';

class InternetErrorPage extends StatelessWidget {
  const InternetErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return WillPopScope(
      onWillPop: ()async{
        appState.activeWidget = "LoginWidget";
        appState.currentState=1;
        return false;
      },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
                child:  Center(child: Text(''
                    'Internet connection error'),)
            ),
            SizedBox(
              height: 200,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child:ElevatedButton(onPressed: (){
                  appState.activeWidget = "LoginWidget";
                  appState.currentState = 1;
                }, child:Text('BACK TO HOME')))
          ],
        )
    );
  }
}
