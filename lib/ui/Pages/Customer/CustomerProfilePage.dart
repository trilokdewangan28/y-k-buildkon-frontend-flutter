import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'package:real_state/ui/Pages/Customer/EditCustomerDetailPage.dart';

import '../Error/SpacificErrorPage.dart';
import '../ImagePickerPage.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({Key? key}) : super(key: key);

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  bool _mounted = false;
  bool _isFirstLoadRunning = false;
  

  //==========================================first load method
  _fetchCustomerDetails(appState)async{
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    var url = Uri.parse(ApiLinks.customerProfile);
    //print(appState.token);
    final res = await StaticMethod.userProfile(appState.token, url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        appState.customerDetails = res['result'];
        if(_mounted){
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        //print(res);
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        if(_mounted){
          setState(() {
            _isFirstLoadRunning=false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _fetchCustomerDetails(appState);
          });
        }
      }
    }
  }

  @override
  void initState() {
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _fetchCustomerDetails(appState);
    super.initState();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return RefreshIndicator(
      color: bluishClr,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            appState.activeWidget = "PropertyListPage";
            appState.currentState = 0;
          },
          child: _isFirstLoadRunning == true?  Center(child: StaticMethod.progressIndicator(),) :Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Column(
                  children: [
                    //-------------------------------------------profile pic and edit btn
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white70,
                            child: appState.customerDetails.isNotEmpty ? appState.customerDetails['customer_profilePic']
                                .isNotEmpty
                                ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  '${ApiLinks.accessCustomerProfilePic}/${appState.customerDetails['customer_profilePic']}',
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  // Other CachedNetworkImage properties
                                )
                            )
                                :const Icon(Icons.person,
                                size: 70, color: Colors.black)
                                : Container(),
                          ),
                        ),
                        Positioned(
                            bottom: 20,
                            right: 10,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: bluishClr,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImagePickerPage(
                                              userDetails:
                                              appState.customerDetails,
                                              forWhich: 'customerProfilePic',
                                            )));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Theme.of(context).primaryColorLight,
                                  )),
                            ))
                      ],
                    ),

                    //------------------------------------------Name
                    Text(
                      '${appState.customerDetails['customer_name']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    //------------------------------------------Email
                    Text(
                      '${appState.customerDetails['customer_email']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),

                    //------------------------------------------mobile
                    Text(
                      '${appState.customerDetails['customer_mobile']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),

                    //------------------------------------------edit btn
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: bluishClr,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCustomerDetailPage(customerDetails: appState.customerDetails,)));
                            },
                            child: Text(
                              'Edit Details',
                              style:
                              TextStyle(color: Theme.of(context).primaryColorLight),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),

                    //-----------------------------------------your visit request
                    GestureDetector(
                      onTap: (){
                        appState.activeWidget = 'VisitRequestedListPage';
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Card(
                          color: Get.isDarkMode?Colors.white12 : Theme.of(context).primaryColorLight,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(Icons.book_outlined),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text('Your Visit Request'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 15,
                    // ),

                    //----------------------------------------your favorite property
                    GestureDetector(
                      onTap: (){
                        appState.activeWidget = "FavoritePropertyListPage";
                      },
                      child:Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Card(
                          color: Get.isDarkMode?Colors.white12 : Theme.of(context).primaryColorLight,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(Icons.favorite_outline),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text('Your Favorite Properties'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),

                    //----------------------------------------logout btn
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: InkWell(
                          onTap: () async {
                            //StaticMethod.logout(appState);
                            appState.deleteToken(appState.userType);
                            appState.token = "";
                            await Future.delayed(const Duration(
                                milliseconds:
                                100)); // Add a small delay (100 milliseconds)

                            appState.deleteUserType();
                            appState.userType = "";
                            await Future.delayed(
                                const Duration(milliseconds: 100));

                            appState.customerDetails = {};
                            appState.customerDetails.clear();
                            appState.adminDetails = {};
                            appState.adminDetails.clear();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            
                            await appState.fetchUserType();
                            Future.delayed(const Duration(milliseconds: 100));

                            appState.fetchToken(appState.userType);
                            Future.delayed(const Duration(milliseconds: 100));

                            appState.activeWidget = "PropertyListPage";
                            appState.currentState = 0;
                          },
                          child:  Card(
                            child:const  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Log Out',
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        onRefresh: () async {
          appState.activeWidget = appState.activeWidget;
        });
  }
}

//   ${ApiLinks.accessCustomerProfilePic}/${appState.customerDetails['c_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}
