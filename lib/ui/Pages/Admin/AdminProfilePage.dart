import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/services/ThemeService/theme.dart';

import '../Error/SpacificErrorPage.dart';
import '../ImagePickerPage.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool _mounted = false;
  bool _isFirstLoadRunning = false;

  //==========================================first load method
  _fetchAdminDetails(appState)async{
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    var url = Uri.parse(ApiLinks.adminProfile);
    //print(appState.token);
    final res = await StaticMethod.userProfile(appState.token, url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        appState.adminDetails = res['result'][0];
        _mounted=true;
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
        //appState.activeWidget = "SpacificErrorPage";
        if(_mounted){
          setState(() {
            _isFirstLoadRunning=false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _fetchAdminDetails(appState);
          });
        }
      }
    }
  }

  @override
  void initState() {
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _fetchAdminDetails(appState);
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
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return RefreshIndicator(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            appState.adminDetails={};
            appState.activeWidget = "PropertyListPage";
            appState.currentState = 0;
          },
          child: _isFirstLoadRunning == true ?  Center(child: StaticMethod.progressIndicator(),) :Container(
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                            backgroundColor: Colors.grey,
                            backgroundImage:
                            appState.adminDetails['admin_profilePic'].length > 0
                                ? NetworkImage(
                              '${ApiLinks.accessAdminProfilePic}/${appState.adminDetails['admin_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                            )
                                : null,
                            // Set to null if there is no profile picture
                            child: appState.adminDetails['admin_profilePic'].isEmpty
                                ? const Icon(Icons.person,
                                size: 70,
                                color: Colors
                                    .black) // Centered icon when no profile picture
                                : null, // No child when there is a profile picture, since it's set as backgroundImage
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
                                              appState.adminDetails,
                                              forWhich: 'adminProfilePic',
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
                      '${appState.adminDetails['admin_name'].toUpperCase()} (ADMIN)',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    //------------------------------------------Email
                    Text(
                      '${appState.adminDetails['admin_email']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),

                    //------------------------------------------mobile
                    Text(
                      '${appState.adminDetails['admin_mobile']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),

                    // //------------------------------------------edit btn
                    // Container(
                    //     margin: const EdgeInsets.symmetric(vertical: 15),
                    //     child: ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //             backgroundColor: Theme.of(context).hintColor,
                    //             elevation: 4
                    //         ),
                    //         onPressed: (){},
                    //         child: Text('Edit Details',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),)
                    //     )
                    // ),
                    const SizedBox(
                      height: 20,
                    ),

                    //-----------------------------------------customer visit request
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // width: MediaQuery.of(context).size.width*0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: InkWell(
                          onTap: () {
                            appState.activeWidget =
                            "CustomerVisitRequestListPage";
                            appState.currentState = 1;
                          },
                          child: Card(
                            color: Get.isDarkMode? Colors.white12: Theme.of(context).primaryColorLight,
                            child:  Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.book_outlined,color: bluishClr,),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text('Customer Visit Request'),
                              ],
                            ),
                          ),
                        )),

                    //const SizedBox(height: 5,),

                    //----------------------------------------customer payment history
                    // Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 20),
                    //     //width: MediaQuery.of(context).size.width*0.85,
                    //     height: MediaQuery.of(context).size.height * 0.07,
                    //     child: InkWell(
                    //       onTap: () {},
                    //       child: Card(
                    //         color: Theme.of(context).primaryColorLight,
                    //         child:  Row(
                    //           children: [
                    //             const SizedBox(
                    //               width: 15,
                    //             ),
                    //             Icon(Icons.payment,color: Theme.of(context).primaryColor,),
                    //             const SizedBox(
                    //               width: 15,
                    //             ),
                    //             const Text('Customer Payment History'),
                    //           ],
                    //         ),
                    //       ),
                    //     )),

                    // const SizedBox(height: 15,),

                    //----------------------------------------sold property list
                    // Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 20),
                    //     // width: MediaQuery.of(context).size.width*0.85,
                    //     height: MediaQuery.of(context).size.height * 0.07,
                    //     child: InkWell(
                    //       onTap: () {},
                    //       child: Card(
                    //         color: Theme.of(context).primaryColorLight,
                    //         child:  Row(
                    //           children: [
                    //             const SizedBox(
                    //               width: 15,
                    //             ),
                    //             Icon(Icons.business,color: Theme.of(context).primaryColor,),
                    //             const SizedBox(
                    //               width: 15,
                    //             ),
                    //             const Text('sold property list'),
                    //           ],
                    //         ),
                    //       ),
                    //     )),

                    //----------------------------------------customer list
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // width: MediaQuery.of(context).size.width*0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: InkWell(
                          onTap: () {
                            appState.activeWidget = "CustomerListPage";
                          },
                          child: Card(
                            color: Get.isDarkMode? Colors.white12: Theme.of(context).primaryColorLight,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.list_alt_outlined,color: bluishClr,),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text('customer list'),
                              ],
                            ),
                          ),
                        )),
                    // const SizedBox(height: 15,),

                    //----------------------------------------employee list
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // width: MediaQuery.of(context).size.width*0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: InkWell(
                          onTap: () {
                            appState.activeWidget = "EmployeeListPage";
                          },
                          child: Card(
                            color: Get.isDarkMode? Colors.white12: Theme.of(context).primaryColorLight,
                            child:  Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.real_estate_agent_outlined,color: bluishClr,),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text('Employee List'),
                              ],
                            ),
                          ),
                        )),
                    // const SizedBox(height: 15,),

                    //----------------------------------------LIST NEW PROPERTY
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // width: MediaQuery.of(context).size.width*0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: InkWell(
                          onTap: () {
                            appState.activeWidget = "AddNewPropertyWidget";
                          },
                          child: Card(
                            color: Get.isDarkMode? Colors.white12: Theme.of(context).primaryColorLight,
                            child:  Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.add_business_outlined,color: bluishClr,),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text('Add New Property'),
                              ],
                            ),
                          ),
                        )),
                    //const SizedBox(height: 15,),

                    //----------------------------------------LIST NEW PROPERTY
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // width: MediaQuery.of(context).size.width*0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: InkWell(
                          onTap: () {
                            appState.activeWidget = "AddNewProjectWidget";
                          },
                          child: Card(
                            color:Get.isDarkMode? Colors.white12: Theme.of(context).primaryColorLight,
                            child:  Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.add_business_outlined,color: bluishClr,),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text('Add New Project'),
                              ],
                            ),
                          ),
                        )),

                    //----------------------------------------logout btn
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.5,
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
                            await Future.delayed(const Duration(milliseconds: 100));

                            appState.customerDetails = {};
                            appState.customerDetails.clear();
                            appState.adminDetails = {};
                            appState.adminDetails.clear();
                            await Future.delayed(const Duration(milliseconds: 100));

                            appState.activeWidget = "PropertyListPage";
                            appState.currentState = 0;

                            await appState.fetchUserType();
                            Future.delayed(const Duration(milliseconds: 100));

                            appState.fetchToken(appState.userType);
                            Future.delayed(const Duration(milliseconds: 100));
                          },
                          child: Card(
                            color: Get.isDarkMode? Colors.white12: Theme.of(context).primaryColorLight,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ]
            ),
          ),
        ),
        onRefresh: () async {
          _isFirstLoadRunning=false;
          _mounted=true;
          _fetchAdminDetails(appState);
          appState.activeWidget = appState.activeWidget;
        });
  }
}
