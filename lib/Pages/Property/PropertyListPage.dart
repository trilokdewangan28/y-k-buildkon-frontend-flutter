
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Offer/OfferSlider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({Key? key}) : super(key: key);

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  bool filterApplied = false;
  bool _mounted = false;

  Color houseColor = Colors.white;
  Color flatColor = Colors.white;
  Color plotColor = Colors.white;
  bool houseTapped = false;
  bool flatTapped = false;
  bool plotTapped = false;

  int minPrice = 1;
  int maxPrice = 100000000;
  int propertyId = 0;
  String selectedCity = "";
  String selectedPropertyName = "";
  
  //===================================project related variable
  bool _isProjectLoading = false;
  int projectId = 1;
  String selectedName='';
  List<dynamic> projectList = [];
  //==========================================first load method
  _fetchProject(appState)async{
    if(_mounted){
      setState(() {
        _isProjectLoading= true;
      });
    }
    var url = Uri.parse(ApiLinks.fetchProject);
    final res = await StaticMethod.fetchProject(url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        projectList = res['result'];
        if(_mounted){
          setState(() {
            _isProjectLoading = false;
          });
        }
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.green);
      }
    }
  }

  //============================================================================FILTER VARIABLE
  final List<String> propertyType = [
    'All',
    'House',
    'Flat',
    'Plot',
    'Office Space',
    'Shop/Showroom',
    'Commercial Land'
  ];
  String selectedPropertyType = "All";

  // String onSelectType = "All";

  final List<String> bhk = ['0', '1', '2', '3', '4', '5'];
  int selectedBhk = 0;

  //int onSelectBhk= 0;

  final List<String> floor = ['0', '1', '2', '3', '4', '5'];
  int selectedFloor = 0;

  //int onSelectFloor = 0;

  final List<String> garden = ['None', 'Yes', 'No'];
  String selectedGarden = 'None';

  //String onSelectGarden = "None";

  final List<String> parking = ['None', 'Yes', 'No'];
  String selectedParking = 'None';

  //String onSelectParking = "None";

  final List<String> furnished = ['None', 'Yes', 'No'];
  String selectedFurnished = "None";

  //String onSelectFurnished="None";

  final List<String> available = ['None', 'Available', 'Not Available','Sold'];
  String selectedAvailability = "Available";

  //String onSelectAvailability = "Yes";

  List<dynamic> filteredProperties = [];


  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 6;

  bool _isFirstLoadRunning = false;
  bool _isOfferLoading = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  //==========================================first load method
  _firstLoad(appState)async{
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    Map<String,dynamic> paginationOptions = {
      "page":page,
      "limit":limit
    };
    var url = Uri.parse(ApiLinks.fetchAllPropertiesWithPaginationAndFilter);
    final res = await StaticMethod.fetchAllPropertyWithPaginationAndFilter(appState,paginationOptions,url,
        propertyName: selectedPropertyName,
        selectedCity: selectedCity,
        minPrice: minPrice,
        maxPrice: maxPrice,
        selectedPropertyType: selectedPropertyType,
        selectedBhk: selectedBhk,
        selectedFloor: selectedFloor,
        selectedGarden: selectedGarden,
        selectedParking: selectedParking,
        selectedFurnished: selectedFurnished,
        selectedAvailability: selectedAvailability,
      projectId: projectId
    );

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        appState.propertyList = res['result'];
        if(_mounted){
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        //print(res['error']);
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        if(_mounted){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _firstLoad(appState);
          });
        }
      }
    }
  }

  //==========================================LOAD MORE METHOD
  void _loadMore(appState) async {

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
      var url = Uri.parse(ApiLinks.fetchAllPropertiesWithPaginationAndFilter);
      final res = await StaticMethod.fetchAllPropertyWithPaginationAndFilter(appState,paginationOptions,url,
          propertyName: selectedPropertyName,
          selectedCity: selectedCity,
          minPrice: minPrice,
          maxPrice: maxPrice,
          selectedPropertyType: selectedPropertyType,
          selectedBhk: selectedBhk,
          selectedFloor: selectedFloor,
          selectedGarden: selectedGarden,
          selectedParking: selectedParking,
          selectedFurnished: selectedFurnished,
          selectedAvailability: selectedAvailability,
        projectId: projectId
      );
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if(res['result'].length>0){
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                appState.propertyList.addAll(res['result']);
                _isFirstLoadRunning = false;
              });
            }
          }else{
            if(_mounted){
              setState(() {
                _hasNextPage = false;
              });
            }
            StaticMethod.showDialogBar('no more content available', Colors.green);
          }
        } else {
          //print(res['error']);
          appState.error = res['error'];
          appState.errorString=res['message'];
          appState.fromWidget=appState.activeWidget;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _hasNextPage=true;
            _firstLoad(appState);
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
  
  
  //=================================================FETCH OFFER LIST
  _loadOffer(appState)async{
    if(_mounted){
      setState(() {
        _isOfferLoading = true;
      });
    }
    var url = Uri.parse(ApiLinks.fetchOfferList);
    final res = await StaticMethod.fetchOfferList(url);
    if(res.isNotEmpty){
      if(res['success']==true){
        appState.offerList = res['result'];
        if(_mounted){
          setState(() {
            _isOfferLoading=false;
          });
        }
      }else{
        // display some another widget for message
      }
    }
  }



  late ScrollController _controller;
  @override
  void initState() {
    ///print('initstate methond called');
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _fetchProject(appState);
    _mounted=true;
    _firstLoad(appState);
    _mounted = true;
    _loadOffer(appState);
    _mounted = true;
    _controller = ScrollController()..addListener(() => _loadMore(appState));
    //print('initstate called');
    super.initState();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  setTheState() {
    setState(() {});
  }

  //===================================SHOW FILTER CONTAINER
  void _showFilterContainer(appState, context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            double dropDownCardWidth = MyConst.deviceWidth(context)*0.43;
            double dropDownCardHeight =
                MyConst.deviceHeight(context) * 0.06;
            double fontSizeScaleFactor =
                MyConst.deviceWidth(context) / MyConst.referenceWidth;
            double smallBodyText = MyConst.smallTextSize*fontSizeScaleFactor;
            return Container(
                color: Theme.of(context).primaryColorLight,
                height: MyConst.deviceHeight(context) * 0.8,
                width: MyConst.deviceWidth(context),
                padding: EdgeInsets.only(top: MyConst.deviceHeight(context)*0.02),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'FILTER OPTION',
                        style: TextStyle(
                            fontSize: MyConst.mediumSmallTextSize*fontSizeScaleFactor, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                        child: Container(
                      width: MyConst.deviceWidth(context),
                      child: SingleChildScrollView(
                          child: Container(
                            width: MyConst.deviceWidth(context),
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).viewInsets.top + 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MyConst.deviceHeight(context)*0.01,
                                ),
                                //===========================SPACIFICATION CONTAINER
                                Container(
                                  //width: MyConst.deviceWidth(context)*0.7,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: MyConst.deviceHeight(context)*0.015,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: MyConst.deviceHeight(context)*0.010, vertical: MyConst.deviceHeight(context)*0.010),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //==========================PROPERTY TYPE
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Select Property Type',
                                                style: TextStyle(
                                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                  fontWeight: FontWeight.w500
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MyConst.deviceHeight(context)*0.01,
                                            ),
                                            Card(
                                              color: Theme.of(context).primaryColorLight,
                                              child: Container(
                                                  height: dropDownCardHeight*0.8,
                                                  child: Center(
                                                    child: DropdownButton<String>(
                                                      value: selectedPropertyType,
                                                      alignment: Alignment.center,
                                                      elevation: 16,
                                                      underline: Container(),
                                                      onChanged: (String? value) {
                                                        setState(() {
                                                          selectedPropertyType = value!;
                                                        });
                                                      },
                                                      items: propertyType
                                                          .map<DropdownMenuItem<String>>(
                                                              (String value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text('${value}',
                                                                  softWrap: true,
                                                                  style: TextStyle(
                                                                      fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                                      overflow: TextOverflow
                                                                          .ellipsis)),
                                                            );
                                                          }).toList(),
                                                    ),
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      


                                      //==========================PROPERTY BHK
                                      selectedPropertyType == 'House' ||
                                          selectedPropertyType == "Flat"
                                          ? Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Select Property BHK',
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MyConst.deviceWidth(context)*0.010,
                                            ),
                                            Card(
                                              color: Theme.of(context).primaryColorLight,
                                              child: Container(
                                                  height: dropDownCardHeight*0.8,
                                                  child: Center(
                                                    child: DropdownButton<String>(
                                                      value: selectedBhk.toString(),
                                                      alignment: Alignment.center,
                                                      elevation: 16,
                                                      underline: Container(),
                                                      onChanged: (String? value) {
                                                        setState(() {
                                                          selectedBhk = int.parse(value!);
                                                        });
                                                      },
                                                      items: bhk
                                                          .map<DropdownMenuItem<String>>(
                                                              (String value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text('${value}',
                                                                  softWrap: true,
                                                                  style: TextStyle(
                                                                      fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                                      overflow: TextOverflow
                                                                          .ellipsis)),
                                                            );
                                                          }).toList(),
                                                    ),
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                          : Container(),
                                      


//==========================PROPERTY FLOOR
                                      selectedPropertyType == 'House'
                                          ? Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child:  Text(
                                              'Select No. Of Floors',
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MyConst.deviceWidth(context)*0.010,
                                          ),
                                          Card(
                                            color: Theme.of(context).primaryColorLight,
                                            child:Container(
                                                height: dropDownCardHeight*0.8,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: selectedFloor.toString(),
                                                    alignment: Alignment.center,
                                                    elevation: 16,
                                                    underline: Container(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        selectedFloor = int.parse(value!);
                                                      });
                                                    },
                                                    items: floor
                                                        .map<DropdownMenuItem<String>>(
                                                            (String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text('${value}',
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                                    overflow: TextOverflow
                                                                        .ellipsis)),
                                                          );
                                                        }).toList(),
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      )
                                          : Container(),




//==========================isGarden facility
                                      selectedPropertyType == 'House'
                                          ? Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Garden Availibility',
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MyConst.deviceWidth(context)*0.010,
                                          ),
                                          Card(
                                            color: Theme.of(context).primaryColorLight,
                                            child:Container(
                                                height: dropDownCardHeight*0.8,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: selectedGarden,
                                                    alignment: Alignment.center,
                                                    elevation: 16,
                                                    underline: Container(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        selectedGarden = value!;
                                                      });
                                                    },
                                                    items: garden
                                                        .map<DropdownMenuItem<String>>(
                                                            (String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text('${value}',
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                                    overflow: TextOverflow
                                                                        .ellipsis)),
                                                          );
                                                        }).toList(),
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      )
                                          : Container(),




//==========================isParking facility
                                      selectedPropertyType == 'House'
                                          ? Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child:  Text(
                                              'Parking Facility',
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MyConst.deviceWidth(context)*0.010,
                                          ),
                                          Card(
                                            color: Theme.of(context).primaryColorLight,
                                            child: Container(
                                                height: dropDownCardHeight*0.8,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: selectedParking,
                                                    alignment: Alignment.center,
                                                    elevation: 16,
                                                    underline: Container(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        selectedParking = value!;
                                                      });
                                                    },
                                                    items: parking
                                                        .map<DropdownMenuItem<String>>(
                                                            (String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text('${value}',
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                                    overflow: TextOverflow
                                                                        .ellipsis)),
                                                          );
                                                        }).toList(),
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      )
                                          : Container(),


//==========================isFurnished facility
                                      selectedPropertyType == 'House' ||
                                          selectedPropertyType == 'Flat'
                                          ? Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child:  Text(
                                              'Furnished Or Not',
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MyConst.deviceWidth(context)*0.010,
                                          ),
                                          Card(
                                            color: Theme.of(context).primaryColorLight,
                                            child: Container(
                                                height: dropDownCardHeight*0.8,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: selectedFurnished,
                                                    alignment: Alignment.center,
                                                    elevation: 16,
                                                    underline: Container(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        selectedFurnished = value!;
                                                      });
                                                    },
                                                    items: furnished
                                                        .map<DropdownMenuItem<String>>(
                                                            (String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text('${value}',
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                                    overflow: TextOverflow
                                                                        .ellipsis)),
                                                          );
                                                        }).toList(),
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      )
                                          : Container(),


//==========================AVAILABILITY
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child:  Text(
                                              'Available Or Not',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:MyConst.smallTextSize*fontSizeScaleFactor),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MyConst.deviceWidth(context)*0.010,
                                          ),
                                          Card(
                                            color: Theme.of(context).primaryColorLight,
                                            child: Container(
                                                height: dropDownCardHeight*0.8,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: selectedAvailability,
                                                    alignment: Alignment.center,
                                                    elevation: 16,
                                                    underline: Container(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        selectedAvailability = value!;
                                                      });
                                                    },
                                                    items: available
                                                        .map<DropdownMenuItem<String>>(
                                                            (String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text('${value}',
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                                    overflow: TextOverflow
                                                                        .ellipsis)),
                                                          );
                                                        }).toList(),
                                                  ),
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),

                                //============================PRICE RANGE CONTAINER
                                Row(
                                  children: [
                                    //===================================FILTER BY MIN PRICE
                                    Expanded(child: Container(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Card(
                                        color: Theme.of(context).primaryColorLight,
                                        shadowColor: Colors.black,
                                        elevation: 2,
                                        child: TextField(
                                          onChanged: (value) {
                                            minPrice = int.parse(value);
                                          },
                                          controller: TextEditingController(
                                              text: minPrice.toString()),
                                          keyboardType: TextInputType.number,
                                          style:  TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                          textAlignVertical: TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          decoration:  InputDecoration(
                                            contentPadding: const EdgeInsets.only(bottom: 5),
                                            labelText: ' min price',
                                            labelStyle: TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                            border: InputBorder.none,
                                          ),
                                          cursorOpacityAnimates: false,
                                        ),
                                      ),
                                    ),),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    //===================================FILTER BY MAX PRICE
                                    Expanded(child: Container(
                                      padding: const EdgeInsets.only(
                                        right: 15,
                                      ),
                                      child: Card(
                                        color: Theme.of(context).primaryColorLight,
                                        shadowColor: Colors.black,
                                        elevation: 2,
                                        child: TextField(
                                          onChanged: (value) {
                                            maxPrice = int.parse(value);
                                          },
                                          controller:
                                          TextEditingController(text: maxPrice.toString()),
                                          keyboardType: TextInputType.number,
                                          style:  TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                          textAlignVertical: TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(bottom: 5),
                                            labelText: ' max price',
                                            labelStyle: TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                            border: InputBorder.none,
                                          ),
                                          cursorOpacityAnimates: false,
                                        ),
                                      ),
                                    ),)
                                  ],
                                ),
                                const SizedBox(height: 10,),

                                //===================================FILTER BY NAME
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Card(
                                    color: Theme.of(context).primaryColorLight,
                                    shadowColor: Colors.black,
                                    elevation: 2,
                                    child: TextField(
                                      onChanged: (value) {
                                        selectedPropertyName = value;
                                      },
                                      controller: TextEditingController(
                                          text: selectedPropertyName),
                                      keyboardType: TextInputType.text,
                                      style:  TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration:  InputDecoration(
                                        contentPadding: const EdgeInsets.only(bottom: 5),
                                        labelText: 'Filter By Name',
                                        labelStyle: TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                        border: InputBorder.none,
                                        prefixIcon:  Icon(Icons.search,size: MyConst.deviceHeight(context)*0.02,),
                                      ),
                                      cursorOpacityAnimates: false,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //===================================FILTER BY CITY
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Card(
                                    color: Theme.of(context).primaryColorLight,
                                    shadowColor: Colors.black,
                                    elevation: 2,
                                    child: TextField(
                                      onChanged: (value) {
                                        selectedCity = value;
                                      },
                                      controller:
                                      TextEditingController(text: selectedCity),
                                      keyboardType: TextInputType.text,
                                      style:  TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(bottom: 5),
                                        labelText: 'Filter By City',
                                        labelStyle: TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                        border: InputBorder.none,
                                        prefixIcon: const Icon(Icons.search),
                                      ),
                                      cursorOpacityAnimates: false,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).errorColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          ),
                                          onPressed: () {
                                            page=1;
                                            minPrice = 1;
                                            maxPrice = 100000000;
                                            propertyId = 0;
                                            selectedCity = "";
                                            selectedPropertyType = "All";
                                            selectedBhk = 0;
                                            selectedFloor = 0;
                                            selectedGarden = "None";
                                            selectedParking = "None";
                                            selectedFurnished = "None";
                                            selectedAvailability = "Available";
                                            selectedPropertyName = "";
                                            _hasNextPage=true;
                                            _isFirstLoadRunning=false;
                                            _firstLoad(appState);
                                            filterApplied = false;
                                            Navigator.pop(context);
                                            setTheState();
                                          },
                                          child: Text(
                                            'Clear Filter',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color:Theme.of(context).primaryColorLight),
                                          )),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                          )
                                        ),
                                          onPressed: () {
                                            page=1;
                                            _hasNextPage=true;
                                            _isFirstLoadRunning=false;
                                            _firstLoad(appState);
                                            filterApplied = true;
                                            Navigator.pop(context);
                                            setTheState();
                                          },
                                          child:  Text(
                                              'Apply Filter',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColorLight,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    )
                    )
                  ],
                ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return RefreshIndicator(
        child: Container(
          child: Column(
            children: [
              //===========================NAME FILTER CONTAINER
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MyConst.deviceHeight(context) * 0.015),
                child: Row(
                  children: [
                    //=====================================FILTER BY NAME TEXTFIELD
                    Flexible(
                      child: Card(
                        color: Theme.of(context).primaryColorLight,
                        //shadowColor: Colors.black,
                        elevation: 1,
                        child: TextField(
                          onChanged: (value) {
                            selectedPropertyName = value;
                            _hasNextPage=true;
                            page=1;
                            //setState(() {
                            _isFirstLoadRunning=false;
                            _firstLoad(appState);
                            //});
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: MyConst.mediumSmallTextSize *
                                  fontSizeScaleFactor),
                          textAlignVertical: TextAlignVertical.center,
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 5),
                            labelText: 'Filter By Name',
                            labelStyle: TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search,size: MyConst.deviceHeight(context)*0.025,),
                          ),
                          cursorOpacityAnimates: false,
                        ),
                      ),
                    ),
                    SizedBox(width: MyConst.deviceWidth(context)*0.010,),
                    //=====================================FILTER BTN
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: MyConst.deviceHeight(context)*0.045,
                              width: MyConst.deviceHeight(context)*0.045,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/Icons/filter.png',
                                  height: MyConst.deviceHeight(context)*0.045,
                                  width: MyConst.deviceHeight(context)*0.045,
                                ),
                                onPressed: () {
                                  //selectedPropertyType = "All";
                                  _showFilterContainer(appState, context);
                                },
                              ),
                            ),
                            filterApplied
                                ? Positioned(
                                bottom:
                                MyConst.deviceHeight(context) * 0.010,
                                right:
                                MyConst.deviceHeight(context) * 0.012,
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size:
                                  MyConst.deviceHeight(context) * 0.010,
                                ))
                                : Container()
                          ],
                        ),
                        // SizedBox(
                        //   height: MyConst.deviceHeight(context) * 0.001,
                        // ),
                        // Text(
                        //   'Filters',
                        //   style: TextStyle(fontSize: 10 * fontSizeScaleFactor),
                        // )
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.010,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: _isProjectLoading
                    ? const Center(child:LinearProgressIndicator())
                    : projectList.length!=0
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Under The Project',
                      style: TextStyle(
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const Spacer(),
                    Card(
                        color: Theme.of(context).primaryColorLight,
                        elevation: 1,
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: DropdownButton<String>(
                            value: selectedName.length==0 ? projectList[0]['project_name']:selectedName,
                            alignment: Alignment.center,
                            elevation: 16,
                            underline: Container(),
                            onChanged: (value) {
                              // This is called when the user selects an item.
                              setState(() {
                                selectedName = value!;
                                projectId= projectList.firstWhere((element) => element['project_name'] == value)['project_id'].toInt();
                                //print(projectId);
                                _mounted=true;
                                _hasNextPage=true;
                                page=1;
                                _isFirstLoadRunning=false;
                                _isLoadMoreRunning=false;
                                _firstLoad(appState);
                                //print('selected property type is ${selectedPropertyType}');
                              });
                            },
                            ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                            items: projectList
                                .map<DropdownMenuItem<String>>(
                                    (dynamic project) {
                                  return DropdownMenuItem<String>(
                                    value: project['project_name'],
                                    child: Text('${project['project_name']}',
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                            overflow: TextOverflow
                                                .ellipsis)),
                                  );
                                }).toList(),
                          ),
                        )
                    ),
                  ],
                )
                    : Container(),
              ),

              //=====================================OFFER CONTAINER
              Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.015,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: _isOfferLoading
                      ? Shimmer.fromColors(
                      baseColor: Theme.of(context).primaryColor,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)
                        ),
                      )
                  )
                      : appState.offerList.isNotEmpty ? const OfferSlider() : Container()
              ),
              SizedBox(
                height: MyConst.deviceHeight(context) * 0.02,
              ),

              //=====================================PROPERTY LIST CONTAINER
              _isFirstLoadRunning==false
                  ? appState.propertyList.isNotEmpty
                  ? Container(child: Flexible(
                  child: ListView.builder(
                    itemCount: appState.propertyList.length,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      final property = appState.propertyList[index];
                      double propertyRating = 0.0;
                      int totalRating = int.parse(property['total_rating']);
                      int totalReview = property['review_count'];
                      if(totalRating!=0){
                        propertyRating = totalRating/totalReview;
                      }
                      return InkWell(
                        onTap: () {
                          //print(property['property_id']);
                          appState.p_id = property['property_id'];
                          appState.activeWidget = "PropertyDetailPage";
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.height * 0.010,
                            ),
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
                                    //height: MyConst.deviceHeight(context)*0.1,
                                    //width: MyConst.deviceWidth(context)*0.25,
                                    margin: const EdgeInsets.all(8),
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
                                            const LinearProgressIndicator(),
                                            errorWidget: (context, url,
                                                error) =>
                                            const Icon(Icons.error),
                                            height:
                                            MyConst.deviceHeight(
                                                context) *
                                                0.12,
                                            width: MyConst.deviceWidth(
                                                context) *
                                                0.25,
                                            fit: BoxFit.fill,
                                          )
                                              : ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            child: Image.asset(
                                              'assets/images/home.jpg',
                                              width:
                                              MyConst.deviceWidth(
                                                  context) *
                                                  0.25,
                                              height:
                                              MyConst.deviceHeight(
                                                  context) *
                                                  0.12,
                                              fit: BoxFit.fill,
                                            ),
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
                                              '${property['property_name'].toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: MyConst.smallTextSize *
                                                    fontSizeScaleFactor,
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
                                                  MyConst.smallTextSize *
                                                      fontSizeScaleFactor,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),

                                            //=======================PRICE ROW SECTION
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.currency_rupee_sharp,
                                                  color:
                                                  Theme.of(context).primaryColor,
                                                  size: MyConst
                                                      .mediumSmallTextSize *
                                                      fontSizeScaleFactor,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${property['property_price']}',
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
                                                  Theme.of(context).primaryColor,
                                                  size: MyConst
                                                      .mediumSmallTextSize *
                                                      fontSizeScaleFactor,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                      '${property['property_locality']}, ${property['property_city']}',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize:
                                                        MyConst.smallTextSize *
                                                            fontSizeScaleFactor,
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
                                                      MyConst.smallTextSize *
                                                          fontSizeScaleFactor,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                )
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
                  )),)
                  :  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 150,),
                  Center(child: Text(
                    'No Such Properties',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: MyConst.largeTextSize*fontSizeScaleFactor
                    ),
                  ),)
                ],
              )
                  : Container(
                margin: EdgeInsets.symmetric(
                    vertical: MyConst.deviceHeight(context) * 0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

              //================================loading more
              _isLoadMoreRunning == true
                  ? const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Container(),

              // _hasNextPage == false
              //     ? appState.propertyList.isNotEmpty ? Container(
              //   color: Colors.amber,
              //   child: const Center(
              //     child: Text('You have fetched all of the content'),
              //   ),
              // ) : Container()
              //     : Container()
            ],
          ),
        ),
        onRefresh: () async {
          // setState(() {
          _isOfferLoading=false;
          _hasNextPage=true;
          page=1;
          projectId=1;
          _isFirstLoadRunning=false;
          _isLoadMoreRunning=false;
          _firstLoad(appState);
          appState.activeWidget = appState.activeWidget;
          //});
        });
  }
}
