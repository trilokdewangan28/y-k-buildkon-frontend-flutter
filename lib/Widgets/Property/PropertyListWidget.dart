
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Error/EmptyPropertyPage.dart';
import 'package:real_state/Pages/Property/PropertyListPage.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/Provider/MyProvider.dart';

class PropertyListWidget extends StatefulWidget {
  const PropertyListWidget({Key? key}) : super(key: key);

  @override
  State<PropertyListWidget> createState() => _PropertyListWidgetState();
}

class _PropertyListWidgetState extends State<PropertyListWidget> {
  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<MyProvider>(context);
    Widget propertyContent = Container();
    List<Map<String, dynamic>> propertyListDemo = [];
    var url = Uri.parse(ApiLinks.fetchAllProperties);
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<Map<String, dynamic>>(
        future: StaticMethod.fetchAllProperties(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a circular progress indicator while waiting for data.
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: const LinearProgressIndicator(),
              )
            );
          } else if (snapshot.hasError ) {
            // Handle error state.
            if (snapshot.error is SocketException) {
              // Handle network-related errors (internet connection loss).
              return const InternetErrorPage();
            } else {
              // Handle other errors (server error or unexpected error).
              return SpacificErrorPage(errorString: snapshot.error.toString(),fromWidget: appState.activeWidget,);
            }
          }
          else if(snapshot.hasData){

            // Display user details when data is available.
            if(snapshot.data!['success']==true){
              final propertyResult = snapshot.data!;
              //print('property list is ${propertyResult}');
              if(propertyResult['result'].length!=0){
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
                appState.propertyList = propertyListDemo;


                propertyContent = const PropertyListPage();
              }else{
                propertyContent = const EmptyPropertyPage(text: "empty property list",);
              }
              return propertyContent;
            }else{
              return SpacificErrorPage(errorString: snapshot.data!['message'],fromWidget: appState.activeWidget,);
            }
          }
          else{
            return SpacificErrorPage(errorString: snapshot.error.toString(),fromWidget: appState.activeWidget,);
          }
        },
      ),
    );
  }
}
