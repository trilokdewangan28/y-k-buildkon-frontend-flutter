import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';

import '../../../config/StaticMethod.dart';


class CustomerDetailPage extends StatefulWidget {
  const CustomerDetailPage({super.key});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        appState.customerDetails={};
          appState.activeWidget="CustomerListPage";
        },
      child: Container(
        color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //=======================================PROFILE PIC
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white70,
                      child: appState.customerDetails['customer_profilePic']
                          .isNotEmpty
                          ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl:
                            '${ApiLinks.accessCustomerProfilePic}/${appState.customerDetails['customer_profilePic']}',
                            placeholder: (context, url) =>  StaticMethod.progressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            // Other CachedNetworkImage properties
                          )
                      )
                          :const CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person,
                            size: 70, color: Colors.black),
                      ) ,
                    ),
                  ),
                ],
              ),
              //=========================================DETAIL CONTAINER
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                child: Column(
                  children: [
                    Card(
                      color: Get.isDarkMode?Colors.white12 :Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Customer Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.customerDetails['customer_name']}'
                        ),
                      ),
                    ),
                    Card(
                      color: Get.isDarkMode?Colors.white12 :Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color:
                              Get.isDarkMode? Colors.white70:Theme.of(context).primaryColor,
                              size: MyConst
                                  .mediumSmallTextSize *
                                  fontSizeScaleFactor,
                            ),
                            const SizedBox(width: 4,),
                            const Text(
                              'Customer Mobile',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),],),
                        subtitle: Text(
                            '${appState.customerDetails['customer_mobile']}'
                        ),
                      ),
                    ),
                    Card(
                      color: Get.isDarkMode?Colors.white12 :Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color:
                              Get.isDarkMode? Colors.white70:Theme.of(context).primaryColor,
                              size: MyConst
                                  .mediumSmallTextSize *
                                  fontSizeScaleFactor,
                            ),
                            const SizedBox(width: 4,),
                            const Text(
                              'Customer Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                            '${appState.customerDetails['customer_email']}'
                        ),
                      ),
                    ),
                    Card(
                      color: Get.isDarkMode?Colors.white12 :Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color:
                              Get.isDarkMode? Colors.white70:Theme.of(context).primaryColor,
                              size: MyConst
                                  .mediumSmallTextSize *
                                  fontSizeScaleFactor,
                            ),
                            const SizedBox(width: 4,),
                            const Text(
                              'Customer Address',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],),
                        subtitle: Text(
                            '${appState.customerDetails['customer_address']}, ${appState.customerDetails['customer_locality']}, ${appState.customerDetails['customer_city']}, ${appState.customerDetails['customer_pincode']}'
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
