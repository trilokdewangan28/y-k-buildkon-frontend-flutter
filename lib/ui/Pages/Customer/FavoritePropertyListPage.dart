import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';


import 'package:real_state/controller/MyProvider.dart';


import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/controller/PropertyListController.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/ui/Widgets/Other/RatingDisplayWidgetTwo.dart';

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
            StaticMethod.showDialogBar('No more content available', Colors.black);
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
    PropertyListController controller = Get.find();
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
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            child:Column(
              children: [
                //=====================================PROPERTY LIST CONTAINER
                _isFirstLoadRunning==true 
                    ? const Center(child: LinearProgressIndicator(),)   
                    : favoritePropertyList.isNotEmpty 
                    ? _propertyListAnimation(appState,controller)
                    : const Center(
                  child: Text('Empty Favorite Property'),
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
  _propertyListAnimation(appState, PropertyListController controller){
    return Container(child: Flexible(
        child:ListView.builder(
          itemCount: favoritePropertyList.length,
          controller: _controller,
          itemBuilder: (context, index) {
            final property = favoritePropertyList[index];
            print(property);
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
                          controller.appBarContent.value = 'Favorite Property Detail';
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
              //property['pi_name'].length>0 ? Text('${property['pi_name'][0]}') : Container()
            ],
          ),
        ));
  }
}
