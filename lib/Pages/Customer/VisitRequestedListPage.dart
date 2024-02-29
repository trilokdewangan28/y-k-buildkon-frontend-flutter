import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

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
        appState.visitRequestedPropertyList = res['result'];
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
            color: Theme.of(context).primaryColorLight,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                //=====================================FILTER USING REQUEST STATUS
                Container(
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
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
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
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
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
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
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
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
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
                ),

                //=====================================PROPERTY LIST CONTAINER
                _isFirstLoadRunning == false
                    ? appState.visitRequestedPropertyList.isNotEmpty
                    ? Expanded(
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
                                color: Theme.of(context).primaryColorLight,
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
                                                  Text(
                                                    '₹',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                        FontWeight.w600),
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
                                                    color: Theme.of(context)
                                                        .primaryColor,
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
                    ))
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
                  margin: const EdgeInsets.only(top: 5),
                  child: const LinearProgressIndicator(),
                ),

                //================================loading more
                _isLoadMoreRunning == true
                    ? Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  child: const Center(
                    child: CircularProgressIndicator(),
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
}
