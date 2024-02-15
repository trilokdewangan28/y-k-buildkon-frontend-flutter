import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Customer/EditCustomerDetailPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/ImagePickerPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
class EmployeeProfileWidget extends StatefulWidget {
  const EmployeeProfileWidget({super.key});

  @override
  State<EmployeeProfileWidget> createState() => _EmployeeProfileWidgetState();
}

class _EmployeeProfileWidgetState extends State<EmployeeProfileWidget> {
  bool _mounted = false;
  bool _isFirstLoadRunning = false;

  //==========================================first load method
  _fetchEmployeeDetails(appState)async{
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    var url = Uri.parse(ApiLinks.employeeProfile);
    //print(appState.token);
    final res = await StaticMethod.userProfile(appState.token, url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        appState.employeeDetails = res['result'];
        if(_mounted){
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        if(_mounted){
          setState(() {
            _isFirstLoadRunning=false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _fetchEmployeeDetails(appState);
          });
        }
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>SpacificErrorPage(error: res['error'],errorString: res['message'],fromWidget: appState.activeWidget,)));
      }
    }
  }
  
  @override
  void initState() {
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _fetchEmployeeDetails(appState);
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
            appState.activeWidget = "PropertyListPage";
            appState.currentState = 0;
          },
          child: Container(
            child: _isFirstLoadRunning==true
                ? const Center(child: CircularProgressIndicator(),)
                : Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColorLight,
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
                              child: false
                                  ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    '${ApiLinks.accessCustomerProfilePic}/${appState.employeeDetails['profilePic']}',
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    // Other CachedNetworkImage properties
                                  )
                              )
                                  :const Icon(Icons.person,
                                  size: 70, color: Colors.black) ,
                            ),
                          ),
                          //===========================EDIT PROFILE PIC BUTTON
                          // Positioned(
                          //     bottom: 20,
                          //     right: 10,
                          //     child: CircleAvatar(
                          //       radius: 15,
                          //       backgroundColor: Theme.of(context).primaryColor,
                          //       child: IconButton(
                          //           onPressed: () {
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ImagePickerPage(
                          //                       userDetails:
                          //                       appState.employeeDetails,
                          //                       forWhich: 'employeeProfilePic',
                          //                     )));
                          //           },
                          //           icon: Icon(
                          //             Icons.edit,
                          //             size: 15,
                          //             color: Theme.of(context).primaryColorLight,
                          //           )),
                          //     ))
                        ],
                      ),

                      //------------------------------------------Name
                      Text(
                        '${appState.employeeDetails['name']}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      //------------------------------------------Email
                      Text(
                        '${appState.employeeDetails['email']}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),

                      //------------------------------------------mobile
                      Text(
                        '${appState.employeeDetails['mobile']}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),

                      //------------------------------------------edit btn
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              onPressed: () {
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCustomerDetailPage(customerDetails: appState.customerDetails,)));
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Card(
                          color: Theme.of(context).primaryColorLight,
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
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    //appState.activeWidget = 'VisitRequestedListWidget';
                                  },
                                  icon: const Icon(
                                    Icons.arrow_right,
                                    size: 40,
                                  ))
                            ],
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 15,
                      // ),

                      //----------------------------------------your favorite property
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Card(
                          color: Theme.of(context).primaryColorLight,
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
                              IconButton(
                                  onPressed: () {
                                    //appState.activeWidget = "FavoritePropertyListWidget";
                                  },
                                  icon: const Icon(
                                    Icons.arrow_right,
                                    size: 40,
                                  ))
                            ],
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
                              color: Theme.of(context).primaryColorLight,
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
        ),
        onRefresh: () async {
          _mounted=false;
          _fetchEmployeeDetails(appState);
        });
  }
}
