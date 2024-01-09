import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/ServerErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Property/EmptyPropertyPage.dart';
import 'package:real_state/Pages/Property/VisitRequestedListPage.dart';
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
      "c_id":appState.customerDetails['c_id']
    };
    return Container(
      child: FutureBuilder<Map<String, dynamic>>(
        future: StaticMethod.fetchVisitRequestedList(data,url),
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
              final propertyResult = snapshot.data!;
              //print('property list is ${propertyResult}');
              if(propertyResult['result'].length!=0){
                appState.visitRequestedPropertyList= propertyResult['result'];
                visitRequestContent = VisitRequestedListPage();
              }else{
                visitRequestContent = EmptyPropertyPage();
              }
              return visitRequestContent;
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
