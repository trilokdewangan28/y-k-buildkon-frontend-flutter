import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Error/EmptyPropertyPage.dart';
import 'package:real_state/Pages/Customer/VisitRequestedListPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
class VisitRequestedListWidget extends StatefulWidget {
  const VisitRequestedListWidget({Key? key}) : super(key: key);

  @override
  State<VisitRequestedListWidget> createState() => _VisitRequestedListWidgetState();
}

class _VisitRequestedListWidgetState extends State<VisitRequestedListWidget> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    Widget visitRequestContent = Container();
    var url = Uri.parse(ApiLinks.fetchVisitRequestedList);
    var data = {
      "c_id":appState.customerDetails['customer_id']
    };
    List<Map<String, dynamic>> propertyListDemo = [];
    return false ? Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child:  FutureBuilder<Map<String, dynamic>>(
        future: StaticMethod.fetchVisitRequestedList(appState.token, data,url),
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
              return SpacificErrorPage();
            }
          }
          else if(snapshot.hasData){

            // Display user details when data is available.
            if(snapshot.data!['success']==true){
              final propertyResult = snapshot.data!;
              //print('property list is ${propertyResult}');
              if(propertyResult['result'].length!=0){
                appState.visitRequestedPropertyList= propertyResult['result'];
                for (var propertyData in propertyResult['result']) {
                  if (propertyData['pi_name'] != null && propertyData['pi_name'] != '') {
                    // Split pi_name into an array of image URLs
                    List<String> imageUrls = propertyData['pi_name'].split(',');
                    // Update the propertyData with the new imageUrls array
                    propertyData['pi_name'] = imageUrls;
                  } else {
                    // Handle the case where there are no images
                    propertyData['pi_name'] = []; // or an empty array []
                  }

                  // Add the updated propertyData to the propertyList
                  propertyListDemo.add(propertyData);
                }
                appState.visitRequestedPropertyList=propertyListDemo;
                visitRequestContent = const VisitRequestedListPage();
              }else{
                visitRequestContent = const EmptyPropertyPage(text: "empty request",);
              }
              return visitRequestContent;
            }else{
              appState.error=snapshot.data!['error'];
              appState.errorString= snapshot.data!['message'];
              appState.fromWidget = appState.activeWidget;
              return SpacificErrorPage();
            }
          }
          else{
            appState.error='';
            appState.errorString= snapshot.data!['message'];
            appState.fromWidget = appState.activeWidget;
            return SpacificErrorPage();
          }
        },
      ),
    ) :VisitRequestedListPage();
  }
}
