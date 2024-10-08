
import 'package:JAY_BUILDCON/ui/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';

class SpacificErrorPage extends StatefulWidget {

  const SpacificErrorPage({super.key});

  @override
  _SpacificErrorPageState createState() => _SpacificErrorPageState();
}

class _SpacificErrorPageState extends State<SpacificErrorPage> {
  bool knowMore = false;
  String btncontent = "know more";
  @override
  void initState() {
    MyProvider appState = Provider.of<MyProvider>(context,listen: false);
    if(appState.errorString.toLowerCase() == "invalid token" || appState.errorString.toLowerCase() == "no token provided"){
      appState.token = "";
      appState.userType = "";
      appState.deleteToken(appState.userType);
      appState.deleteUserType();
      appState.activeWidget = "LoginWidget";
      Navigator.pop(context);
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        appState.activeWidget = appState.fromWidget;
        appState.currentState=appState.currentState;
      },
        child: RefreshIndicator(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Error Page'),
              centerTitle: true,
            ),
            body: Container(
              color: Theme.of(context).primaryColorLight,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.2),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //==========================500 text
                      Text(
                        '500',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error
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
                              color: Theme.of(context).colorScheme.error,
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
                              color: Theme.of(context).colorScheme.error,
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
                              color: Theme.of(context).colorScheme.error,
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
          ),
          onRefresh: () async {
            appState.activeWidget = appState.fromWidget;
            Navigator.pop(context);
          },
        )
    );
  }
}

