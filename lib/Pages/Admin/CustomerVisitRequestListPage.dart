import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

class CustomerVisitRequestListPage extends StatefulWidget {
  const CustomerVisitRequestListPage({Key? key}) : super(key: key);

  @override
  State<CustomerVisitRequestListPage> createState() =>
      _CustomerVisitRequestListPageState();
}

class _CustomerVisitRequestListPageState
    extends State<CustomerVisitRequestListPage> {
  String requestStatus = "";
  Color statusColor = Colors.orange;
  Color houseColor = Colors.white;
  Color flatColor = Colors.white;
  Color plotColor = Colors.white;
  bool houseTapped = false;
  bool flatTapped = false;
  bool plotTapped = false;
  int selectedRequestStatus = 4;

  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 5;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  //==========================================first load method
  _firstLoad(appState)async{
    setState(() {
      _isFirstLoadRunning = true;
    });
    Map<String,dynamic> paginationOptions = {
      "page":page,
      "limit":limit
    };
    var url = Uri.parse(ApiLinks.fetchCustomerRequest);
    final res = await StaticMethod.fetchCustomerRequestWithPagination(appState, url, paginationOptions,appState.token,selectedRequestStatus: selectedRequestStatus);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        appState.filteredCustomerRequestList = res['result'];
        setState(() {
          _isFirstLoadRunning = false;
        });
      } else {
      }
    }
  }

  //==========================================load modre method
  void _loadMore(appState) async {

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300
    ) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      page += 1; // Increase _page by 1
      Map<String,dynamic> paginationOptions = {
        "page":page,
        "limit":limit
      };
      var url = Uri.parse(ApiLinks.fetchCustomerRequest);
      final res = await StaticMethod.fetchCustomerRequestWithPagination(appState, url, paginationOptions,appState.token,selectedRequestStatus: selectedRequestStatus);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if(res['result'].length>0){
            //print('succes is true and result is ${res['result']}');
            setState(() {
              appState.filteredCustomerRequestList.addAll(res['result']);
              _isFirstLoadRunning = false;
            });
          }else{
            setState(() {
              _hasNextPage = false;
            });
            Fluttertoast.showToast(
              msg: 'No More Content Available',
              toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
              gravity: ToastGravity.TOP, // Toast position
              backgroundColor: Colors.black, // Background color of the toast
              textColor: Colors.green, // Text color of the toast message
              fontSize: 16.0, // Font size of the toast message
            );
          }
        } else {
          //print('unable to fetch property show error page');
        }
      }
      setState(() {
        _isLoadMoreRunning=false;
      });
    }
  }

  late ScrollController _controller;
  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    _firstLoad(appState);
    _controller = ScrollController()..addListener(() => _loadMore(appState));
    //print('initstate called');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return RefreshIndicator(
        child: Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const SizedBox(height: 10,),
          //=====================================FILTER USING REQUEST STATUS
          Container(
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {
                    houseTapped = !houseTapped;
                    flatTapped = false;
                    plotTapped = false;
                    if (houseTapped == true) {
                      selectedRequestStatus = 0;
                      _hasNextPage=true;
                      page=1;
                      //setState(() {
                      _isFirstLoadRunning=false;
                      _firstLoad(appState);
                      //});
                    } else {
                      selectedRequestStatus = 4;
                      _hasNextPage=true;
                      page=1;
                      //setState(() {
                      _isFirstLoadRunning=false;
                      _firstLoad(appState);
                      //});
                    }
                    //setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 110,
                    decoration: BoxDecoration(
                        color: houseTapped
                            ? Theme.of(context).hintColor
                            : Theme.of(context).primaryColor,
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                        child: Text(
                          'Pending',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    flatTapped = !flatTapped;
                    houseTapped = false;
                    plotTapped = false;
                    if (flatTapped == true) {
                      selectedRequestStatus = 1;
                      _hasNextPage=true;
                      page=1;
                      //setState(() {
                      _isFirstLoadRunning=false;
                      _firstLoad(appState);
                    } else {
                      selectedRequestStatus = 4;
                      _hasNextPage=true;
                      page=1;
                      //setState(() {
                      _isFirstLoadRunning=false;
                      _firstLoad(appState);
                    }
                    //setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 110,
                    decoration: BoxDecoration(
                        color: flatTapped
                            ? Theme.of(context).hintColor
                            : Theme.of(context).primaryColor,
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                        child: Text(
                          'Accepted',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    plotTapped = !plotTapped;
                    houseTapped = false;
                    flatTapped = false;
                    if (plotTapped == true) {
                      selectedRequestStatus = 2;
                      _hasNextPage=true;
                      page=1;
                      //setState(() {
                      _isFirstLoadRunning=false;
                      _firstLoad(appState);
                    } else {
                      selectedRequestStatus = 4;
                      _hasNextPage=true;
                      page=1;
                      //setState(() {
                      _isFirstLoadRunning=false;
                      _firstLoad(appState);
                    }
                    //setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 110,
                    decoration: BoxDecoration(
                        color: plotTapped
                            ? Theme.of(context).hintColor
                            : Theme.of(context).primaryColor,
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                        child: Text(
                          'Completed',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ),
                )
              ],
            ),
          ),
          //=====================================PROPERTY LIST CONTAINER
          _isFirstLoadRunning==false
              ? appState.filteredCustomerRequestList.isNotEmpty
                   ? Expanded(
              child: ListView.builder(
                itemCount: appState.filteredCustomerRequestList.length,
                itemBuilder: (context, index) {
                  final property = appState.filteredCustomerRequestList[index];
                  if (property['v_status'] == 0) {
                    requestStatus = "Pending";
                    statusColor = Colors.orange;
                  } else if (property['v_status'] == 1) {
                    requestStatus = "Accepted";
                    statusColor = Colors.green;
                  } else {
                    requestStatus = "Completed";
                    statusColor = Colors.red;
                  }
                  return InkWell(
                    onTap: () {
                      appState.selectedCustomerRequest = property;
                      appState.activeWidget = "CustomerVisitRequestDetailPage";
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        child: Card(
                          shadowColor: Colors.black,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //==============================PROPERTY IMAGE CONTAINER
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: property['customer_profilePic'].length > 0
                                        ? CachedNetworkImage(
                                      imageUrl:
                                      '${ApiLinks.accessCustomerProfilePic}/${property['customer_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                      placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    )
                                        : Image.asset(
                                      'assets/images/home.jpg',
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                              ),

                              //==============================CUSTOMER REQUEST DETAIL CONTAINER
                              Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //=======================CUSTOMER NAME CONTAINER
                                        Text(
                                          '${property['customer_name'].toUpperCase()}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          softWrap: true,
                                        ),


                                        //=======================AREA TEXT
                                        Text(
                                          '${property['property_name']}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500),
                                        ),

                                        //=======================PRICE ROW SECTION
                                        Row(
                                          children: [
                                            Text(
                                              '₹',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).hintColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${property['property_price']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),

                                        //=======================LOCATION ROW SECTION
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              color: Theme.of(context).hintColor,
                                              size: 20,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${property['property_locality']}, ${property['property_city']}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                        //=======================RATING ROW SECTION
                                        Row(
                                          children: [
                                            RatingDisplayWidgetTwo(
                                              rating: property['property_rating'].toDouble(),
                                            ),
                                            Text('(${property['property_ratingCount']})')
                                          ],
                                        ),

                                        //========================REQUEST STATUS
                                        Text(
                                          requestStatus,
                                          style: TextStyle(color: statusColor),
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
              child: Text('no such request',style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MyConst.largeTextSize*fontSizeScaleFactor
              ),),
            ),
          )
              : Container(
            margin: const EdgeInsets.only(top: 300),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
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
              ? appState.filteredCustomerRequestList.isNotEmpty ? Container(
            color: Colors.amber,
            child: const Center(
              child: Text('You have fetched all of the content'),
            ),
          ) : Container()
              : Container()
        ],
      ),
    ),
        onRefresh: ()async{
          // setState(() {
          _hasNextPage=true;
          page=1;

          _isFirstLoadRunning=false;
          _isLoadMoreRunning=false;
          _firstLoad(appState);
          appState.activeWidget = "CustomerVisitRequestListWidget";
          //});
        }
    );
  }
}
