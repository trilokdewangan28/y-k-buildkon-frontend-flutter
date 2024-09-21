import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/ui/Pages/Admin/AdminProfilePage.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/EmptyPropertyPage.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/InternetErrorPage.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/SpacificErrorPage.dart';
class AdminProfileWidget extends StatefulWidget {
  const AdminProfileWidget({super.key});

  @override
  State<AdminProfileWidget> createState() => _AdminProfileWidgetState();
}

class _AdminProfileWidgetState extends State<AdminProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    Widget profileContent = Container();
    var url = Uri.parse(ApiLinks.adminProfile);
    var token = appState.token;
    return  Container(
        color: Theme.of(context).primaryColorLight,
        height: MediaQuery.of(context).size.height,
        child:FutureBuilder<Map<String, dynamic>>(
          future: StaticMethod.userProfile(token, url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a circular progress indicator while waiting for data.
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError ) {
              // Handle error state.
              if (snapshot.error is SocketException) {
                // Handle network-related errors (internet connection loss).
                return const InternetErrorPage();
              } else {
                appState.error='';
                appState.errorString= snapshot.data!['message'];
                appState.fromWidget = appState.activeWidget;
                return const SpacificErrorPage();
              }
            }
            else if(snapshot.hasData){

              // Display user details when data is available.
              if(snapshot.data!['success']==true){
                final adminResult = snapshot.data!;
                if(adminResult['result'].length!=0){
                  //print(adminResult['result'][0]);
                  appState.adminDetails= adminResult['result'][0];
                  profileContent = const AdminProfilePage();
                }else{
                  profileContent = const EmptyPropertyPage(text: "empty admin details",backWidget: 'PropertyListPage',);
                }
                return profileContent;
              }else{
                appState.error=snapshot.data!['error'];
                appState.errorString= snapshot.data!['message'];
                appState.fromWidget = appState.activeWidget;
                return const SpacificErrorPage();
              }
            }
            else{
              appState.error='';
              appState.errorString= snapshot.data!['message'];
              appState.fromWidget = appState.activeWidget;
              return const SpacificErrorPage();
            }
          },
        )
    );
  }
}
