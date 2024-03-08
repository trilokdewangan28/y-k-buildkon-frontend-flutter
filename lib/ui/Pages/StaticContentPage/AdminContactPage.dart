import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminContactPage extends StatefulWidget {
  const AdminContactPage({super.key});

  @override
  State<AdminContactPage> createState() => _AdminContactPageState();
}

class _AdminContactPageState extends State<AdminContactPage> {
  bool _mounted=false;
  bool _isDataLoading=false;
  Map<String,dynamic> adminContact = {};
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

  //=====================================================FETCH ADMIN CONTACT
  _fetchAdminContact(appState)async{
    _mounted=true;
    if(_mounted){
      setState(() {
        _isDataLoading = true;
      });
    }
    var data = {"p_id":appState.p_id};
    var url = Uri.parse(ApiLinks.fetchAdminContact);
    final res = await StaticMethod.fetchAdminContact(url);
    if(res.isNotEmpty){
      if(res['success']==true){
        if(res['result'].length!=0){
          print(res['result']);
          adminContact = res['result'][0];
          if(mounted){
            setState(() {
              _isDataLoading=false;
            });
          }
        }else {
          if(_mounted){
            setState(() {
              adminContact = {};
            });
          }
        }
        if(_mounted){
          setState(() {
            _isDataLoading=false;
          });
        }
      }else{
        // display some another widget for message
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
          _mounted=true;
          _fetchAdminContact(appState);
        });
      }
    }
  }
  
  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context,listen: false);
    _fetchAdminContact(appState);
    super.initState();
  }
  @override
  void dispose() {
    _mounted=false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar:_appBar('Contact Support', context),
        body: _isDataLoading==true
            ?Container(child: Center(child: StaticMethod.progressIndicator(),),)
            : adminContact.isNotEmpty 
            ? Container(
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
                        _sendEmail("${adminContact['email']}");
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
                        '${adminContact['email']}',
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
                        _makePhoneCall("${adminContact['mobile']}");
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
                        '${adminContact['mobile']}',
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
                        '${adminContact['address']}',
                        style:
                        const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ) : Container(child: Center(child: Text('No Admin Contact'),),),
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
        style: appbartitlestyle,
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

