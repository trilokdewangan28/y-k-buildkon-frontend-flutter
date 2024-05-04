import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/services/ThemeService/theme.dart';

import '../Error/SpacificErrorPage.dart';
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 6;
  String searchItem='';
  bool _mounted = false;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  //==========================================FIRST LOAD CUSTOMER LIST
  _firstLoadCustomerList(appState)async{
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    Map<String,dynamic> paginationOptions = {
      "page":page,
      "limit":limit
    };
    var url = Uri.parse(ApiLinks.fetchCustomerList);
    final res = await StaticMethod.fetchCustomerListWithPagination(appState, url, paginationOptions, appState.token,searchItem: searchItem);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        appState.customerList = res['result'];
        if(_mounted){
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
          _mounted=true;
          _firstLoadCustomerList(appState);
        });
      }
    }
  }

  //==========================================load modre method
  void _loadMoreCustomerList(appState) async {

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300 && _mounted
    ) {
      if(_mounted){
        setState(() {
          _isLoadMoreRunning = true; // Display a progress indicator at the bottom
        });
      }

      page += 1; // Increase _page by 1
      Map<String,dynamic> paginationOptions = {
        "page":page,
        "limit":limit
      };
      var url = Uri.parse(ApiLinks.fetchCustomerList);
      final res = await StaticMethod.fetchCustomerListWithPagination(appState, url, paginationOptions, appState.token,searchItem: searchItem);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if(res['result'].length>0){
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                appState.customerList.addAll(res['result']);
                _isFirstLoadRunning = false;
              });
            }
          }else{
            if(_mounted){
              setState(() {
                _hasNextPage = false;
              });
            }
            StaticMethod.showDialogBar('no more content available', Colors.black);
          }
        } else {
          appState.error = res['error'];
          appState.errorString=res['message'];
          appState.fromWidget=appState.activeWidget;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _firstLoadCustomerList(appState);
          });
        }
      }
      if (_mounted) {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
    }
  }


  late ScrollController _controller;
  @override
  void initState() {
    ///print('initstate methond called');
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _firstLoadCustomerList(appState);
    _mounted = true;
    _controller = ScrollController()..addListener(() => _loadMoreCustomerList(appState));
    //print('initstate called');
    super.initState();
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
            appState.customerList = [];
            appState.activeWidget = "ProfileWidget";
            appState.currentState=1;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0.0,
              title: Text('Customer List'),
            ),
            body: Container(
              child: Column(
                children: [
                  //=============================================FILTER CONTAINER
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MyConst.deviceHeight(context) * 0.015),
                    child: Row(
                      children: [
                        //=====================================FILTER BY NAME TEXTFIELD
                        Flexible(
                          child: Card(
                            color: Get.isDarkMode?Colors.white12 :Theme.of(context).primaryColorLight,
                            //shadowColor: Colors.black,
                            elevation: 1,
                            child: TextField(
                              onChanged: (value) {
                                searchItem = value;
                                _hasNextPage=true;
                                page=1;
                                //setState(() {
                                _isFirstLoadRunning=false;
                                _firstLoadCustomerList(appState);
                                //});
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: MyConst.mediumSmallTextSize *
                                      fontSizeScaleFactor),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                labelText: 'Filter By Name, Email, Mobile, City',
                                labelStyle: TextStyle(fontSize: 15),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                              ),
                              cursorOpacityAnimates: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MyConst.deviceHeight(context) * 0.02,
                  ),

                  //===========================================CUSTOMER LIST CONTAINER
                  _isFirstLoadRunning==false
                      ? appState.customerList.isNotEmpty
                      ? Container(child: Flexible(
                      child: ListView.builder(
                        itemCount: appState.customerList.length,
                        controller: _controller,
                        itemBuilder: (context, index) {
                          final customer = appState.customerList[index];
                          return InkWell(
                            onTap: () {
                              appState.customerDetails = customer;
                              appState.activeWidget = "CustomerDetailPage";
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal:
                                  MediaQuery.of(context).size.height * 0.010,
                                ),
                                child: Card(
                                  shadowColor: Colors.black,
                                  color: Get.isDarkMode? darkGreyClr:Theme.of(context).primaryColorLight,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 0.5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //==============================PROPERTY IMAGE CONTAINER
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        child: Center(
                                          child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: customer['customer_profilePic'].length >
                                                  0
                                                  ? CachedNetworkImage(
                                                imageUrl:
                                                '${ApiLinks.accessCustomerProfilePic}/${customer['customer_ProfilePic']}',
                                                placeholder: (context,
                                                    url) =>
                                                const LinearProgressIndicator(),
                                                errorWidget: (context, url,
                                                    error) =>
                                                const Icon(Icons.error),
                                                height:
                                                MyConst.deviceHeight(
                                                    context) *
                                                    0.1,
                                                width: MyConst.deviceWidth(
                                                    context) *
                                                    0.25,
                                                fit: BoxFit.fill,
                                              )
                                                  : ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10),
                                                  child: Container(
                                                    height:
                                                    MyConst.deviceHeight(
                                                        context) *
                                                        0.12,
                                                    width: MyConst.deviceWidth(
                                                        context) *
                                                        0.25,
                                                    child: const Icon(Icons.person,size: 70,),
                                                  )
                                              )),
                                        ),
                                      ),

                                      //==============================PROPERTY DETAIL CONTAINER
                                      Flexible(
                                          child: Container(
                                            //height: MyConst.deviceHeight(context)*0.1,
                                            width: double.infinity,
                                            margin: const EdgeInsets.all(8),
                                            // padding: const EdgeInsets.symmetric(
                                            //     horizontal: 4, vertical: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                //=======================NAME CONTAINER
                                                Text(
                                                  '${customer['customer_name'].toUpperCase()}',
                                                  style: TextStyle(
                                                    fontSize: MyConst.smallTextSize *
                                                        fontSizeScaleFactor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  softWrap: true,
                                                ),

                                                //=======================MOBILE ROW SECTION
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.email_outlined,
                                                      color: Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                                                      size: MyConst
                                                          .mediumSmallTextSize *
                                                          fontSizeScaleFactor,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        '${customer['customer_email']}',
                                                        style: TextStyle(
                                                            fontSize: MyConst
                                                                .smallTextSize *
                                                                fontSizeScaleFactor,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            overflow: TextOverflow.ellipsis
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    )
                                                  ],
                                                ),

                                                //=======================MOBILE ROW SECTION
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.phone,
                                                      color:
                                                      Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                                                      size: MyConst
                                                          .mediumSmallTextSize *
                                                          fontSizeScaleFactor,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        '${customer['customer_mobile']}',
                                                        style: TextStyle(
                                                            fontSize: MyConst
                                                                .smallTextSize *
                                                                fontSizeScaleFactor,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                        softWrap: true,
                                                      ),
                                                    )
                                                  ],
                                                ),

                                                //=======================LOCATION ROW SECTION
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_outlined,
                                                      color:
                                                      Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                                                      size: MyConst
                                                          .mediumSmallTextSize *
                                                          fontSizeScaleFactor,
                                                    ),
                                                    Flexible(
                                                        child: Text(
                                                          '${customer['customer_locality']}, ${customer['customer_city']} ${customer['customer_pincode']}',
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize:
                                                              MyConst.smallTextSize *
                                                                  fontSizeScaleFactor,
                                                              fontWeight: FontWeight.w500,
                                                              overflow: TextOverflow.ellipsis
                                                          ),
                                                          softWrap: true,
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                )),
                          );
                        },
                      )),)
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100,),
                      Center(child: Text('No Such Properties'),)
                    ],
                  )
                      : Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MyConst.deviceHeight(context) * 0.2),
                    child:  Center(
                        child:StaticMethod.progressIndicator()
                    ),
                  ),

                  //================================loading more
                  _isLoadMoreRunning == true
                      ?  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                        child:StaticMethod.progressIndicator()
                    ),
                  )
                      : Container(),

                ],
              ),
            ),
          ),
        ),
        onRefresh: () async {
          // setState(() {
          _hasNextPage=true;
          page=1;
          _isFirstLoadRunning=false;
          _isLoadMoreRunning=false;
          _firstLoadCustomerList(appState);
          appState.activeWidget = "CustomerListPage";
          //});
        });
  }
}
