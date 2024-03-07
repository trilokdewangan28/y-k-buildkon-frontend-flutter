import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/services/ThemeService/theme.dart';
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
        child: Scaffold(
          backgroundColor: context.theme.backgroundColor,
          appBar:_appBar('Contact Support', context),
          body: Container(
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
                          color: bluishClr,
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
                          color: bluishClr,
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
                          color: bluishClr,
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
        );
  }
  _appBar(appBarContent,context){
    return AppBar(
      foregroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color:Colors.black,
        size: MyConst.deviceHeight(context)*0.030,
      ),
      toolbarHeight: MyConst.deviceHeight(context)*0.060,
      titleSpacing: MyConst.deviceHeight(context)*0.02,
      elevation: 0.0,
      title:Text(
        appBarContent,
        style: titleStyle,
        softWrap: true,
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/ic_launcher.png'
            ),
          ),
        )
      ],
      backgroundColor: Get.isDarkMode
          ? Colors.black45 : Colors.white,
    );
  }
}
