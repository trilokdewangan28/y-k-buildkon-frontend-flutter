import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminContactPage extends StatelessWidget {
  const AdminContactPage({Key? key}) : super(key: key);

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  _sendEmail(String email)async{
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );


    await launchUrl(params);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Contact Support',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //=============================================EMAIL CONTACT
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: IconButton(
                        onPressed: () {
                          _sendEmail("${appState.adminContact['email']}");
                        },
                        icon: Icon(
                          Icons.email,
                          size: 100,
                          color: Theme.of(context).hintColor,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      '${appState.adminContact['email']}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    )),
                  ),


                  //============================================PHONE CONTACT
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: IconButton(
                        onPressed: () {
                          _makePhoneCall("${appState.adminContact['mobile']}");
                        },
                        icon: Icon(
                          Icons.phone,
                          size: 100,
                          color: Theme.of(context).hintColor,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      '${appState.adminContact['mobile']}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    )),
                  ),


                  //============================================COMPANY ADDRESS
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.business,
                          size: 100,
                          color: Theme.of(context).hintColor,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'Company Address',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      '${appState.adminContact['address']}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        });
  }
}
