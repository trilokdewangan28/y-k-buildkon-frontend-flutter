import 'package:flutter/material.dart';
import 'package:real_state/Pages/StaticContentPage/IntroductionPageOne.dart';
import 'package:real_state/Screens/HomeScreen.dart';
import 'package:real_state/config/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(color: Theme.of(context).hintColor),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/ic_launcher.png'),
                    const Text(
                      'Y&K BUILCON',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'LETS CONNECT TO YOUR DREAM',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )))));
  }
}