import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

class FavoritePropertyListPage extends StatefulWidget {
  const FavoritePropertyListPage({Key? key}) : super(key: key);

  @override
  State<FavoritePropertyListPage> createState() =>
      _FavoritePropertyListPageState();
}

class _FavoritePropertyListPageState extends State<FavoritePropertyListPage> {
  bool _mounted=false;
  List<dynamic> favoritePropertyList=[];

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
    var data = {
      "c_id":appState.customerDetails['customer_id']
    };
    var url = Uri.parse(ApiLinks.fetchFavoritePropertyListDetails);
    final res = await StaticMethod.fetchFavoritePropertyListDetails(appState.token, data, url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        favoritePropertyList = res['result'];
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
      var data = {
        "c_id":appState.customerDetails['customer_id']
      };
      var url = Uri.parse(ApiLinks.fetchFavoritePropertyListDetails);
      final res = await StaticMethod.fetchFavoritePropertyListDetails(appState.token, data, url);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if (res['result'].length > 0) {
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                favoritePropertyList.addAll(res['result']);
                _isFirstLoadRunning = false;
              });
            }
          } else {
            if(_mounted){
              setState(() {
                _hasNextPage = false;
              });
            }
            Fluttertoast.showToast(
              msg: 'No More Content Available',
              toastLength: Toast.LENGTH_LONG,
              // Duration for which the toast should be visible
              gravity: ToastGravity.TOP,
              // Toast position
              backgroundColor: Colors.black,
              // Background color of the toast
              textColor: Colors.green,
              // Text color of the toast message
              fontSize: 16.0, // Font size of the toast message
            );
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
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    //print(appState.favoritePropertyList);
    return RefreshIndicator(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            appState.favoritePropertyList=[];
            appState.activeWidget = "ProfileWidget";
          },
          child: Container(
            color: Theme.of(context).primaryColorLight,
            height: MediaQuery.of(context).size.height,
            child:Column(
              children: [
                //=====================================PROPERTY LIST CONTAINER
                _isFirstLoadRunning==true 
                    ? const Center(child: CircularProgressIndicator(),)   
                    : favoritePropertyList.isNotEmpty 
                    ? Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: favoritePropertyList.length,
                      itemBuilder: (context, index) {
                        final property = favoritePropertyList[index];
                        return InkWell(
                          onTap: () {
                            appState.selectedProperty = property;
                            appState.activeWidget = "FavoritePropertyDetailPage";
                          },
                          child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              child: Card(
                                shadowColor: Colors.black,
                                color: Theme.of(context).primaryColorLight,
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
                                            borderRadius: BorderRadius.circular(10),
                                            child: property['pi_name'].length > 0
                                                ? CachedNetworkImage(
                                              imageUrl:
                                              '${ApiLinks.accessPropertyImages}/${property['pi_name'][0]}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                              placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                              const Icon(Icons.error),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.fill,
                                            )
                                                : ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //=======================NAME CONTAINER
                                              Text(
                                                '${property['property_name'].toUpperCase()}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                softWrap: true,
                                              ),

                                              //=======================AREA TEXT
                                              Text(
                                                '${property['property_area']} ${property['property_areaUnit']}',
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
                                                        color: Theme.of(context).primaryColor,
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
                                                    color: Theme.of(context).primaryColor,
                                                    size: 20,
                                                  ),
                                                  Expanded(
                                                      child:Text(
                                                        '${property['property_locality']}, ${property['property_city']}',
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      )
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
                    : const Center(
                  child: Text('Empty Favorite Property'),
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
                    ? favoritePropertyList.isNotEmpty
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
          appState.activeWidget = appState.activeWidget;
        });
  }
}
