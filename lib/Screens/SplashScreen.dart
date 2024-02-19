import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/StaticContentPage/IntroductionPageOne.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Screens/HomeScreen.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    StaticMethod.initialFetch(appState);
    if (appState.token != "" && appState.userType != "") {
      var url=Uri.parse("");
      if (appState.userType == "admin") {
        url = Uri.parse(ApiLinks.adminProfile);
      } else if(appState.userType == "customer"){
        url = Uri.parse(ApiLinks.customerProfile);
      }else if(appState.userType == "employee"){
        url = Uri.parse(ApiLinks.employeeProfile);
      }
      StaticMethod.userProfileInitial(appState.token, url, appState);
    }
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool hasSeenIntroduction = prefs.getBool('hasSeenIntroduction') ?? false;

      if (hasSeenIntroduction) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          // User hasn't seen introduction, navigate to IntroductionPageOne
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const IntroductionPageOne()),
          );

          // Set the flag to indicate that the user has seen the introduction
          prefs.setBool('hasSeenIntroduction', true);
        }
      }
    });
    return SafeArea(child: Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/ic_launcher.png'),
                    Text(
                      'Y&K BUILCON',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold),
                    ),
                     Text(
                      'LETS CONNECT TO YOUR DREAM',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )))));
  }
}