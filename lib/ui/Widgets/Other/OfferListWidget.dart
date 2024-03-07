import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/ui/Pages/Error/EmptyPropertyPage.dart';
import 'package:real_state/ui/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/ui/Pages/Property/PropertyListPage.dart';
class OfferListWidget extends StatefulWidget {
  const OfferListWidget({Key? key}) : super(key: key);

  @override
  State<OfferListWidget> createState() => _OfferListWidgetState();
}

class _OfferListWidgetState extends State<OfferListWidget> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    Widget propertyContent = Container();
    List<Map<String, dynamic>> propertyListDemo = [];
    var url = Uri.parse(ApiLinks.fetchOfferList);
    return Container(
      color: Theme.of(context).primaryColorLight,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<Map<String, dynamic>>(
        future: StaticMethod.fetchOfferList(url),
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
              appState.error='';
              appState.errorString= snapshot.data!['message'];
              appState.fromWidget = appState.activeWidget;
              return const SpacificErrorPage();
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
                propertyContent =  EmptyPropertyPage(text: "empty offer list",backWidget: appState.activeWidget,);
              }
              return propertyContent;
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
      ),
    );
  }
}
