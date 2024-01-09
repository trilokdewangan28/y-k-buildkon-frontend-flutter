import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/StaticContentPage/AdminContactPage.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/ServerErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Property/EmptyPropertyPage.dart';
import 'package:real_state/Pages/Property/PropertyListPage.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/Provider/MyProvider.dart';

class FetchAdminContactWidget extends StatefulWidget {
  const FetchAdminContactWidget({Key? key}) : super(key: key);

  @override
  State<FetchAdminContactWidget> createState() => _FetchAdminContactWidgetState();
}

class _FetchAdminContactWidgetState extends State<FetchAdminContactWidget> {
  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<MyProvider>(context);
    Widget propertyContent = Container();
    var url = Uri.parse(ApiLinks.fetchAdminContact);
    return Container(
      child: FutureBuilder<Map<String, dynamic>>(
        future: StaticMethod.fetchAdminContact(url),
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
              final adminContactResult = snapshot.data!;
              //print('property list is ${propertyResult}');
              if(adminContactResult['result'].length!=0){
                appState.adminContact= adminContactResult['result'][0];
                propertyContent = AdminContactPage();
              }else{
                propertyContent = EmptyPropertyPage();
              }
              return propertyContent;
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
