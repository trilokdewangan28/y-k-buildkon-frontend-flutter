import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/ServerErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Profile/CustomerProfilePage.dart';
import 'package:real_state/Pages/Property/EmptyPropertyPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

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
      child: FutureBuilder<Map<String, dynamic>>(
        future: StaticMethod.customerProfile(token, url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a circular progress indicator while waiting for data.
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError ) {
            // Handle error state.
            if (snapshot.error is SocketException) {
              // Handle network-related errors (internet connection loss).
              return InternetErrorPage();
            } else {
              // Handle other errors (server error or unexpected error).
              return ServerErrorPage(errorString: snapshot.error.toString(),);
            }
          }
          else if(snapshot.hasData){

            // Display user details when data is available.
            if(snapshot.data!['success']==true){
              final customerResult = snapshot.data!;
              if(customerResult['result'].length!=0){
                appState.customerDetails= customerResult['result'];
                profileContent = CustomerProfilePage();
              }else{
                profileContent = EmptyPropertyPage();
              }
              return profileContent;
            }else{
              return SpacificErrorPage(errorString: snapshot.data!['message'],);
            }
          }
          else{
            return ServerErrorPage(errorString: snapshot.error.toString(),);
          }
        },
      ),
    );
  }
}
