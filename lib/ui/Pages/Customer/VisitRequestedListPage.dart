import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/controller/PropertyListController.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/ui/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:intl/intl.dart';

class VisitRequestedListPage extends StatefulWidget {
  const VisitRequestedListPage({Key? key}) : super(key: key);

  @override
  State<VisitRequestedListPage> createState() => _VisitRequestedListPageState();
}

class _VisitRequestedListPageState extends State<VisitRequestedListPage> {
  bool _mounted=false;
  String requestStatus = "";
  Color statusColor = Colors.orange;

  bool pendingTapped = false;
  bool acceptedTapped = false;
  bool completedTapped = false;
  bool cancelledTapped = false;
  int selectedRequestStatus = 4;
  
  List<dynamic> requestList = [];

  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 5;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  //==========================================first load method
  _firstLoad(appState) async {
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    Map<String, dynamic> paginationOptions = {"page": page, "limit": limit};
    var url = Uri.parse(ApiLinks.fetchVisitRequestedList);
    final res = await StaticMethod.fetchVisitRequestedListWithPagination(
        appState, url, paginationOptions, appState.token,
        selectedRequestStatus: selectedRequestStatus);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        if(res['result'].length>0){
          appState.visitRequestedPropertyList = res['result'];
          requestList = res['result'];
          print(res['result'][0]);
          if(_mounted){
            setState(() {
              _isFirstLoadRunning = false;
            });
          }
        }else{
          appState.visitRequestedPropertyList = [];
          requestList = [];
          //print(res['result'][0]);
          if(_mounted){
            setState(() {
              _isFirstLoadRunning = false;
            });
          }
        }
      } else {
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
          _mounted=true;
          _firstLoad(appState);
        });
      }
    }
  }

  //==========================================load modre method
  void _loadMore(appState) async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300 && _mounted) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      page += 1; // Increase _page by 1
      Map<String, dynamic> paginationOptions = {"page": page, "limit": limit};
      var url = Uri.parse(ApiLinks.fetchVisitRequestedList);
      final res = await StaticMethod.fetchVisitRequestedListWithPagination(
          appState, url, paginationOptions, appState.token,
          selectedRequestStatus: selectedRequestStatus);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if (res['result'].length > 0) {
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                appState.visitRequestedPropertyList.addAll(res['result']);
                requestList.addAll(res['result']);
                _isFirstLoadRunning = false;
              });
            }
          } else {
            if(_mounted){
              setState(() {
                _hasNextPage = false;
              });
            }
            StaticMethod.showDialogBar('No more content available', Colors.green);
          }
        } else {
          appState.error = res['error'];
          appState.errorString=res['message'];
          appState.fromWidget=appState.activeWidget;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _firstLoad(appState);
          });
        }
      }
     if(_mounted){
       setState(() {
         _isLoadMoreRunning = false;
       });
     }
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    _mounted=true;
    _firstLoad(appState);
    _controller = ScrollController()..addListener(() => _loadMore(appState));
    //print('initstate called');
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
    PropertyListController controller = Get.find();
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    //print('visit requested property list is : ${appState.visitRequestedPropertyList}');
    return RefreshIndicator(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            appState.visitRequestedPropertyList=[];
            appState.activeWidget = "ProfileWidget";
          },
          child: Container(
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                //=====================================FILTER USING REQUEST STATUS
                _filterContainer(appState, fontSizeScaleFactor),

                //=====================================PROPERTY LIST CONTAINER
                _isFirstLoadRunning == false
                    ? appState.visitRequestedPropertyList.isNotEmpty
                    ? _propertyListAnimation(appState, controller)
                    : Container(
                  margin: const EdgeInsets.only(top: 300),
                  child: Center(
                    child: Text(
                      'no such request',
                      style: TextStyle(
                          fontSize: MyConst.largeTextSize *
                              fontSizeScaleFactor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
                    : Container(
                  height: MediaQuery.of(context).size.height*0.75,
                  margin: const EdgeInsets.only(top: 5),
                  child: Center(
                    child: StaticMethod.progressIndicator(),
                  )
                ),

                //================================loading more
                _isLoadMoreRunning == true
                    ? Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  child:  Center(
                    child:StaticMethod.progressIndicator()
                  ),
                )
                    : Container(),

                //==================================fetched all
                _hasNextPage == false
                    ? appState.visitRequestedPropertyList.isNotEmpty
                    ? Container(
                  color: Colors.amber,
                  child: const Center(
                    child: Text('You have fetched all of the content'),
                  ),
                )
                    : Container()
                    : Container()
              ],
            ),
          ),
        ),
        onRefresh: () async {
          // setState(() {
          _hasNextPage=true;
          page=1;
          _isFirstLoadRunning=false;
          _isLoadMoreRunning=false;
          _mounted=true;
          _firstLoad(appState);
          appState.activeWidget = "VisitRequestedListPage";
        });
  }
  _filterContainer(appState,fontSizeScaleFactor){
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              pendingTapped = !pendingTapped;
              acceptedTapped = false;
              completedTapped = false;
              cancelledTapped = false;
              if (pendingTapped == true) {
                selectedRequestStatus = 0;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
                //});
              } else {
                selectedRequestStatus = 4;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
                //});
              }
              //setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 110,
              decoration: BoxDecoration(
                  color: pendingTapped
                      ? bluishClr
                      : Get.isDarkMode? Colors.white38 : Theme.of(context).primaryColorLight,
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                    'Pending',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: pendingTapped
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).hintColor
                    ),
                  )),
            ),
          ),
          GestureDetector(
            onTap: () {
              acceptedTapped = !acceptedTapped;
              pendingTapped = false;
              completedTapped = false;
              cancelledTapped = false;
              if (acceptedTapped == true) {
                selectedRequestStatus = 1;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
              } else {
                selectedRequestStatus = 4;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
              }
              //setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 110,
              decoration: BoxDecoration(
                  color: acceptedTapped
                      ? bluishClr
                      : Get.isDarkMode? Colors.white38 : Theme.of(context).primaryColorLight,
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child:  Center(
                  child: Text(
                    'Accepted',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: acceptedTapped ? Theme.of(context).primaryColorLight : Theme.of(context).hintColor
                    ),
                  )),
            ),
          ),

          //==================================COMPLETED FILTER BUTTON
          GestureDetector(
            onTap: () {
              completedTapped = !completedTapped;
              pendingTapped = false;
              acceptedTapped = false;
              cancelledTapped=false;
              if (completedTapped == true) {
                selectedRequestStatus = 2;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
              } else {
                selectedRequestStatus = 4;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
              }
              //setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 110,
              decoration: BoxDecoration(
                  color: completedTapped
                      ? bluishClr
                      : Get.isDarkMode? Colors.white38 : Theme.of(context).primaryColorLight,
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child:  Center(
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: completedTapped
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).hintColor,
                    ),
                  )),
            ),
          ),

          //==================================CANCELLED FILTER BUTTON
          GestureDetector(
            onTap: () {
              cancelledTapped = !cancelledTapped;
              pendingTapped = false;
              acceptedTapped = false;
              completedTapped=false;
              if (cancelledTapped == true) {
                selectedRequestStatus = 3;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
              } else {
                selectedRequestStatus = 4;
                _hasNextPage=true;
                page=1;
                //setState(() {
                _isFirstLoadRunning=false;
                _mounted=true;
                _firstLoad(appState);
              }
              //setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 110,
              decoration: BoxDecoration(
                  color: cancelledTapped
                      ? bluishClr
                      : Get.isDarkMode? Colors.white38 : Theme.of(context).primaryColorLight,
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child:  Center(
                  child: Text(
                    'Cancelled',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: cancelledTapped
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).hintColor,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
  _visitRequestedPropertyList(appState,fontSizeScaleFactor){
    return Expanded(
        child: ListView.builder(
          itemCount: appState.visitRequestedPropertyList.length,
          itemBuilder: (context, index) {
            final property =
            appState.visitRequestedPropertyList[index];
            if (property['v_status'] == 0) {
              requestStatus = "Pending";
              statusColor = Colors.orange;
            } else if (property['v_status'] == 1) {
              requestStatus = "Accepted";
              statusColor = Colors.green;
            } else if(property['v_status'] == 1){
              requestStatus = "Completed";
              statusColor = Colors.red;
            }else{
              requestStatus = "Cancelled";
              statusColor = Colors.red;
            }
            return InkWell(
              onTap: () {
                appState.selectedProperty = property;
                appState.activeWidget =
                "VisitRequestedDetailPage";
                // // //print(property['property_id']);
                // appState.p_id = property['property_id'];
                // appState.activeWidget = "VisitRequestedDetailPage";
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 4),
                  child: Card(
                    shadowColor: Colors.black,
                    color: context.theme.backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10)),
                    elevation: 0.5,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        //==============================PROPERTY IMAGE CONTAINER
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Center(
                            child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(10),
                                child: property['pi_name'] !=
                                    null &&
                                    property['pi_name']
                                        .length >
                                        0
                                    ? CachedNetworkImage(
                                  imageUrl:
                                  '${ApiLinks.accessPropertyImages}/${property['pi_name'][0]}',
                                  placeholder: (context,
                                      url) =>
                                  const LinearProgressIndicator(),
                                  errorWidget: (context,
                                      url, error) =>
                                  const Icon(
                                      Icons.error),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                )
                                    : ClipRRect(
                                  borderRadius:
                                  BorderRadius
                                      .circular(10),
                                  child: Image.asset(
                                    'assets/images/home.jpg',
                                    width: 100,
                                  ),
                                )),
                          ),
                        ),

                        //==============================PROPERTY DETAIL CONTAINER
                        Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  //=======================NAME CONTAINER
                                  Text(
                                    '${property['property_name'].toUpperCase()}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      overflow:
                                      TextOverflow.ellipsis,
                                    ),
                                    softWrap: true,
                                  ),

                                  //=======================AREA TEXT
                                  Text(
                                    '${property['property_area']} ${property['property_areaUnit']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight:
                                        FontWeight.w500),
                                  ),

                                  //=======================PRICE ROW SECTION
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.currency_rupee_outlined,
                                        color: Get.isDarkMode?Colors.white70:context.theme.primaryColor,
                                        size: 20,
                                      ),
                                      Text(
                                        '${property['property_price']}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ],
                                  ),

                                  //=======================LOCATION ROW SECTION
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        color: Get.isDarkMode?Colors.white70:context.theme.primaryColor,
                                        size: 20,
                                      ),
                                      Expanded(
                                          child: Text(
                                            '${property['property_locality']}, ${property['property_city']}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w500,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                          ))
                                    ],
                                  ),

                                  //=======================RATING ROW SECTION
                                  Row(
                                    children: [
                                      RatingDisplayWidgetTwo(
                                        rating: property[
                                        'property_rating']
                                            .toDouble(),
                                      ),
                                      Text(
                                          '(${property['property_ratingCount']})')
                                    ],
                                  ),

                                  //========================REQUEST STATUS
                                  Text(
                                    requestStatus,
                                    style: TextStyle(
                                        color: statusColor),
                                  ),

                                  //property['pi_name'].length>0 ? Text('${property['pi_name'][0]}') : Container()
                                ],
                              ),
                            ))
                      ],
                    ),
                  )),
            );
          },
        ));
  }
  
  
  _propertyListAnimation(appState, PropertyListController controller){
    return Container(child: Flexible(
        child:ListView.builder(
          itemCount: requestList.length,
          controller: _controller,
          itemBuilder: (context, index) {
            final property = requestList[index];
            if (property['v_status'] == 0) {
              requestStatus = "Pending";
              statusColor = Colors.orange;
            } else if (property['v_status'] == 1) {
              requestStatus = "Accepted";
              statusColor = Colors.green;
            } else if(property['v_status'] == 1){
              requestStatus = "Completed";
              statusColor = Colors.red;
            }else{
              requestStatus = "Cancelled";
              statusColor = Colors.red;
            }
            double propertyRating = 0.0;
            int totalRating = int.parse(property['total_rating']);
            int totalReview = property['review_count'];
            if (totalRating != 0) {
              propertyRating = totalRating / totalReview;
            }
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 100,
                  child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {
                          //print(property['property_id']);
                          appState.p_id = property['property_id'];
                          appState.activeWidget = "PropertyDetailPage";
                          controller.appBarContent.value = 'Visit Detail';
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.010,
                            ),
                            child: Card(
                              color: Get.isDarkMode ? darkGreyClr : Colors
                                  .white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //==============================PROPERTY IMAGE CONTAINER
                                  _propertyImage(property),

                                  //==============================PROPERTY DETAIL CONTAINER
                                  _propertyDetail(property, propertyRating),
                                ],
                              ),
                            )),
                      )
                  ),
                )
            );
          },
        ))
    );
  }

  _propertyImage(property) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.white12 : Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      width: 100,
      height: 100,
      child: Center(
        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(10),
          child: property['pi_name'].length >
              0
              ? CachedNetworkImage(
            imageUrl:
            '${ApiLinks.accessPropertyImages}/${property['pi_name'][0]}',
            placeholder: (context,
                url) =>
                StaticMethod.progressIndicatorFadingCircle(),
            errorWidget: (context, url,
                error) =>
            const Icon(Icons.error),
            fit: BoxFit.fill,
          )
              : Image.asset(
            'assets/images/home.jpg',
            fit: BoxFit.fill,
          ),),
      ),
    );
  }

  _propertyDetail(property, propertyRating) {
    return Flexible(
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
                '${property['property_name'].toUpperCase()}',
                style: TextStyle(
                  fontSize: MyConst.smallTextSize,
                  fontWeight: FontWeight.w600,
                ),
                softWrap: true,
              ),

              //=======================AREA TEXT
              Text(
                '${property['property_area']}  ${property['property_areaUnit']}',
                softWrap: true,
                style: TextStyle(
                    fontSize:
                    MyConst.smallTextSize,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),

              //=======================PRICE ROW SECTION
              Row(
                children: [
                  Icon(
                    Icons.currency_rupee_sharp,
                    color: Get.isDarkMode ? Colors.white70 : context.theme
                        .primaryColor,
                    size: MyConst
                        .mediumSmallTextSize,
                  ),
                  Flexible(
                    child: Text(
                      '${property['property_price']}',
                      style: TextStyle(
                          fontSize: MyConst
                              .smallTextSize,
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
                    Get.isDarkMode ? Colors.white70 : context.theme
                        .primaryColor,
                    size: MyConst
                        .mediumSmallTextSize,
                  ),
                  Flexible(
                      child: Text(
                        '${property['property_locality']}, ${property['property_city']}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize:
                          MyConst.smallTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ))
                ],
              ),

              //=======================RATING ROW SECTION
              Row(
                children: [
                  RatingDisplayWidgetTwo(
                    rating:
                    propertyRating
                        .toDouble(),
                  ),
                  Flexible(
                    child: Text(
                      '(${property['review_count']})',
                      style: TextStyle(
                          fontSize:
                          MyConst.smallTextSize
                      ),
                      softWrap: true,
                    ),
                  )
                ],
              ),
              //========================REQUEST DATE
              Row(
                children: [
                  Text(
                      'Request Date: '
                  ),
                  Text(
                      DateFormat('dd MMM yyyy').format(DateTime.parse(property['v_date']))
                  )
                ],
              ),

              //========================VISITING DATE
              Row(
                children: [
                  Text(
                      'Visiting Date: '
                  ),
                  Text(
                      DateFormat('dd MMM yyyy').format(DateTime.parse(property['visiting_date']))
                  )
                ],
              ),

              //========================REQUEST STATUS
              Text(
                requestStatus,
                style: TextStyle(
                    color: statusColor),
              ),

              //property['pi_name'].length>0 ? Text('${property['pi_name'][0]}') : Container()
            ],
          ),
        ));
  }
}
