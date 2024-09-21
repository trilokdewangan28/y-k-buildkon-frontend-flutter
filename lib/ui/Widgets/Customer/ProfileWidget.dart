import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/ui/Pages/Customer/CustomerProfilePage.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/EmptyPropertyPage.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/InternetErrorPage.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/SpacificErrorPage.dart';
class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    Widget profileContent = Container();
    var url = Uri.parse(ApiLinks.customerProfile);
    var token = appState.token;
    return Container(
      color: Theme.of(context).primaryColorLight,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<Map<String, dynamic>>(
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
              // Handle other errors (server error or unexpected error).
              appState.error='';
              appState.errorString= snapshot.data!['message'];
              appState.fromWidget = appState.activeWidget;
              return const SpacificErrorPage();
            }
          }
          else if(snapshot.hasData){

            // Display user details when data is available.
            if(snapshot.data!['success']==true){
              final customerResult = snapshot.data!;
              if(customerResult['result'].length!=0){
                appState.customerDetails= customerResult['result'];
                profileContent = const CustomerProfilePage();
              }else{
                profileContent = const EmptyPropertyPage(text: "empty customer details",backWidget: "PropertyListPage",);
              }
              return profileContent;
            }else{
              // appState.error=snapshot.data!['error'];
              // appState.errorString= snapshot.data!['message'];
              // appState.fromWidget = appState.activeWidget;
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
      ),
    );
  }
}
