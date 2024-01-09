import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/ServerErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Property/EmptyPropertyPage.dart';
import 'package:real_state/Pages/Property/VisitRequestedDetailPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
class VisitRequestedDetailWidget extends StatefulWidget {
  const VisitRequestedDetailWidget({Key? key}) : super(key: key);

  @override
  State<VisitRequestedDetailWidget> createState() => _VisitRequestedDetailWidgetState();
}

class _VisitRequestedDetailWidgetState extends State<VisitRequestedDetailWidget> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    Widget requestedPropertyDetailContent = Container();
    var url = Uri.parse(ApiLinks.fetchVisitRequestedPropertyDetails);
    var data = {
      "p_id":appState.requestedPropertyId
    };
    return Container(
      child: FutureBuilder<Map<String, dynamic>>(
        future: StaticMethod.fetchVisitRequestedPropertyDetails(data,url),
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
                appState.selectedProperty= propertyResult['result'];
                requestedPropertyDetailContent = VisitRequestedDetailPage();
              }else{
                requestedPropertyDetailContent = EmptyPropertyPage();
              }
              return requestedPropertyDetailContent;
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
