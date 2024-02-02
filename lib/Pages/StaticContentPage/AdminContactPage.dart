import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/Constant.dart';
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
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Contact Support',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
            ),
            body: Container(
              color: Theme.of(context).primaryColorLight,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //=============================================EMAIL CONTACT
                    const SizedBox(
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
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text(
                            '${appState.adminContact['email']}',
                            style:
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                          )),
                    ),


                    //============================================PHONE CONTACT
                    const SizedBox(
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
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text(
                            '${appState.adminContact['mobile']}',
                            style:
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                          )),
                    ),


                    //============================================COMPANY ADDRESS
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.business,
                            size: 100,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
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
                            const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        );
  }
}
