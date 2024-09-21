import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/SpacificErrorPage.dart';
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
        backgroundColor: context.theme.colorScheme.surface,
        appBar:_appBar('Contact Support', context),
        body: _isDataLoading==true
            ?Container(child: Center(child: StaticMethod.progressIndicator(),),)
            : adminContact.isNotEmpty 
            ? SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //=============================================EMAIL CONTACT
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: IconButton(
                      onPressed: () {
                        _sendEmail("${adminContact['email']}");
                      },
                      icon: const Icon(
                        Icons.email,
                        size: 100,
                        color: bluishClr,
                      )),
                ),
                SizedBox(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: IconButton(
                      onPressed: () {
                        _makePhoneCall("${adminContact['mobile']}");
                      },
                      icon: const Icon(
                        Icons.phone,
                        size: 100,
                        color: bluishClr,
                      )),
                ),
                SizedBox(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.business,
                        size: 100,
                        color: bluishClr,
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text(
                        'Company Address',
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                        '${adminContact['address']}',
                        textAlign: TextAlign.center,
                        style:
                        const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ) : Container(child: const Center(child: Text('No Admin Contact'),),),
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
          margin: const EdgeInsets.only(right: 20),
          child: const CircleAvatar(
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

