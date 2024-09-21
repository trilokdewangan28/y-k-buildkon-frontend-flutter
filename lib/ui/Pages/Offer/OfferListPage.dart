import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/SpacificErrorPage.dart';
class OfferListPage extends StatefulWidget {
  final String fromWidget;
  const OfferListPage({super.key, required this.fromWidget});

  @override
  State<OfferListPage> createState() => _OfferListPageState();
}

class _OfferListPageState extends State<OfferListPage> {
  bool _mounted=false;
  List<dynamic> offerList=[];

  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 10;

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
    var url = Uri.parse(ApiLinks.fetchOfferList);
    final res = await StaticMethod.fetchOfferList(url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        offerList = res['result'];
        if(_mounted){
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SpacificErrorPage()),
        ).then((_) {
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
      var url = Uri.parse(ApiLinks.fetchOfferList);
      final res = await StaticMethod.fetchOfferList(url);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if (res['result'].length > 0) {
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                offerList.addAll(res['result']);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SpacificErrorPage()),
          ).then((_) {
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
    return PopScope(
      canPop: true,
        onPopInvoked: (didPop) {
        appState.activeWidget = widget.fromWidget;
        },
        child: Scaffold(
          backgroundColor: context.theme.colorScheme.surface,
          appBar: _appBar('Offer List'),
          body: _isFirstLoadRunning == true ?  Center(child: StaticMethod.progressIndicator(),) :SizedBox(
            height: MediaQuery.of(context).size.height,
            child: appState.offerList.isNotEmpty
                ? ListView.builder(
                itemCount: appState.offerList.length,
                itemBuilder: (context,index){
                  final offer = appState.offerList[index];
                  final imageUrl = '${ApiLinks.accessOfferImage}/${offer['image_url']}';
                  return InkWell(
                    onTap: (){
                      appState.p_id=offer['property_id'];
                      Navigator.pop(context);
                      appState.activeWidget = "PropertyDetailPage";
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // offer image container
                            SizedBox(
                              width: MyConst.deviceWidth(context)*0.9,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    height: 200,
                                    fit: BoxFit.fitHeight,
                                  )
                              ),
                            ),

                            // offer detail container
                            Container(
                              child: Text(offer['about1']),
                            ),
                            Container(
                              child: Text(offer['about2']),
                            ),
                            Container(
                              child: Text(offer['about3']),
                            )
                          ],
                        )
                    ),
                  );
                }
            )
                : const Center(child: Text('No Any Offers'),),
          )
        )
    );
  }
  _appBar(appBarContent){
    return AppBar(
      leading: IconButton(
        onPressed: (){Get.back();},
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: IconThemeData(
        color: Get.isDarkMode ?  Colors.white70 :Colors.black,
        size: MyConst.deviceHeight(context)*0.030,
      ),
      toolbarHeight: MyConst.deviceHeight(context)*0.060,
      titleSpacing: MyConst.deviceHeight(context)*0.02,
      elevation: 0.0,
      title:Text(
        appBarContent,
        style: appbartitlestyle,
        softWrap: true,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/ic_launcher.png',
                height: 100,
              )
          ),
        ),
      ],
      backgroundColor: Get.isDarkMode
          ? Colors.black45 : Colors.white,
    );
  }
}
