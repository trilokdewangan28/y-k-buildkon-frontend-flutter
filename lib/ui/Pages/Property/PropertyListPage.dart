import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:JAY_BUILDCON/controller/PropertyListController.dart';
import 'package:JAY_BUILDCON/models/PropertyListModel.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:JAY_BUILDCON/ui/Pages/Offer/OfferSlider.dart';
import 'package:JAY_BUILDCON/ui/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({super.key});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  bool filterApplied = false;
  bool _mounted = false;
  PropertyListController controller = Get.find();

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
  String selectedName = '';
  List<dynamic> projectList = [];

  //==========================================first load method
  _fetchProject(appState) async {
    if (_mounted) {
      setState(() {
        _isProjectLoading = true;
      });
    }
    var url = Uri.parse(ApiLinks.fetchProject);
    final res = await StaticMethod.fetchProject(url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('success is true and result is ${res['result']}');
        projectList = res['result'];
        if (_mounted) {
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

  final List<String> available = ['None', 'Available', 'Not Available', 'Sold'];
  String selectedAvailability = "Available";

  //String onSelectAvailability = "Yes";

  List<dynamic> filteredProperties = [];


  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 60;

  bool _isFirstLoadRunning = false;
  bool _isOfferLoading = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  //==========================================first load method
  _firstLoad(appState,plcon) async {
    if (_mounted) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    Map<String, dynamic> paginationOptions = {
      "page": page,
      "limit": limit
    };
    var url = Uri.parse(ApiLinks.fetchAllPropertiesWithPaginationAndFilter);
    final res = await StaticMethod.fetchAllPropertyWithPaginationAndFilter(
        appState, paginationOptions, url,
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
        //print('success is true and result is ${res['result']}');
        appState.propertyList = res['result'];
        controller.assignPropertyList(res['result']);
        //print(appState.propertyList);
        if (_mounted) {
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        //print(res['error']);
        appState.error = res['error'];
        appState.errorString = res['message'];
        appState.fromWidget = appState.activeWidget;
        if (_mounted) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const SpacificErrorPage())).then((_) {
            _mounted = true;
            _firstLoad(appState,plcon);
          });
        }
      }
    }
  }

  //==========================================LOAD MORE METHOD
  void _loadMore(appState, plcon) async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300 && _mounted
    ) {
      if (_mounted) {
        setState(() {
          _isLoadMoreRunning = true; // Display a progress indicator at the bottom
        });
      }

      page += 1; // Increase _page by 1
      Map<String, dynamic> paginationOptions = {
        "page": page,
        "limit": limit
      };
      var url = Uri.parse(ApiLinks.fetchAllPropertiesWithPaginationAndFilter);
      final res = await StaticMethod.fetchAllPropertyWithPaginationAndFilter(
          appState, paginationOptions, url,
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
          if (res['result'].length > 0) {
            //print('success is true and result is ${res['result']}');
            if (_mounted) {
              setState(() {
                appState.propertyList.addAll(res['result']); // Append new properties to the existing list
                _isFirstLoadRunning = false;
              });
            }
          } else {
            if (_mounted) {
              setState(() {
                _hasNextPage = false;
              });
            }
            StaticMethod.showDialogBar(
                'no more content available', Colors.green);
          }
        } else {
          //print(res['error']);
          appState.error = res['error'];
          appState.errorString = res['message'];
          appState.fromWidget = appState.activeWidget;
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const SpacificErrorPage())).then((_) {
            _mounted = true;
            _hasNextPage = true;
            _firstLoad(appState, plcon);
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
  _loadOffer(appState) async {
    if (_mounted) {
      setState(() {
        _isOfferLoading = true;
      });
    }
    var url = Uri.parse(ApiLinks.fetchOfferList);
    final res = await StaticMethod.fetchOfferList(url);
    if (res.isNotEmpty) {
      if (res['success'] == true) {
        appState.offerList = res['result'];
        if (_mounted) {
          setState(() {
            _isOfferLoading = false;
          });
        }
      } else {
        // display some another widget for message
      }
    }
  }


  late ScrollController _controller;

  @override
  void initState() {
    ///print('init state method called');
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    PropertyListController plcon = Get.find();
    _fetchProject(appState);
    _mounted = true;
    _firstLoad(appState,plcon);
    _mounted = true;
    _loadOffer(appState);
    _mounted = true;
    _controller = ScrollController()
      ..addListener(() => _loadMore(appState,plcon));
    //print('init state called');
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
  void _showFilterContainer(appState, plcon,context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            double dropDownCardWidth = MyConst.deviceWidth(context) * 0.43;
            double dropDownCardHeight =
                MyConst.deviceHeight(context) * 0.06;
            double fontSizeScaleFactor =
                MyConst.deviceWidth(context) / MyConst.referenceWidth;
            double smallBodyText = MyConst.smallTextSize * fontSizeScaleFactor;
            return Container(
                color: Get.isDarkMode ? darkGreyClr : Theme
                    .of(context)
                    .primaryColorLight,
                height: MyConst.deviceHeight(context) * 0.8,
                width: MyConst.deviceWidth(context),
                padding: EdgeInsets.only(
                    top: MyConst.deviceHeight(context) * 0.02),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'FILTER OPTION',
                        style: TextStyle(
                            fontSize: MyConst.mediumSmallTextSize *
                                fontSizeScaleFactor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                        child: SizedBox(
                          width: MyConst.deviceWidth(context),
                          child: SingleChildScrollView(
                              child: Container(
                                width: MyConst.deviceWidth(context),
                                padding: EdgeInsets.only(
                                  top: MediaQuery
                                      .of(context)
                                      .viewInsets
                                      .top + 16,
                                  bottom: MediaQuery
                                      .of(context)
                                      .viewInsets
                                      .bottom + 16,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: MyConst.deviceHeight(context) *
                                          0.01,
                                    ),
                                    //===========================SPECIFICATION CONTAINER
                                    Container(
                                      //width: MyConst.deviceWidth(context)*0.7,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: MyConst.deviceHeight(
                                            context) * 0.015,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MyConst.deviceHeight(
                                              context) * 0.010,
                                          vertical: MyConst.deviceHeight(
                                              context) * 0.010),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          //==========================PROPERTY TYPE
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Select Property Type',
                                                    style: TextStyle(
                                                        fontSize: MyConst
                                                            .smallTextSize *
                                                            fontSizeScaleFactor,
                                                        fontWeight: FontWeight
                                                            .w500
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MyConst.deviceHeight(
                                                      context) * 0.01,
                                                ),
                                                Card(
                                                  color: Get.isDarkMode ? Colors
                                                      .white12 : Theme
                                                      .of(context)
                                                      .primaryColorLight,
                                                  child: SizedBox(
                                                      height: dropDownCardHeight *
                                                          0.8,
                                                      child: Center(
                                                        child: DropdownButton<
                                                            String>(
                                                          value: selectedPropertyType,
                                                          alignment: Alignment
                                                              .center,
                                                          elevation: 16,
                                                          underline: Container(),
                                                          onChanged: (
                                                              String? value) {
                                                            setState(() {
                                                              selectedPropertyType =
                                                              value!;
                                                            });
                                                          },
                                                          items: propertyType
                                                              .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                                  (
                                                                  String value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Text(
                                                                      value,
                                                                      softWrap: true,
                                                                      style: TextStyle(
                                                                          fontSize: MyConst
                                                                              .smallTextSize *
                                                                              fontSizeScaleFactor,
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
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Select Property BHK',
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: MyConst
                                                            .smallTextSize *
                                                            fontSizeScaleFactor,
                                                        fontWeight: FontWeight
                                                            .w500
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MyConst.deviceWidth(
                                                      context) * 0.010,
                                                ),
                                                Card(
                                                  color: Get.isDarkMode ? Colors
                                                      .white12 : Theme
                                                      .of(context)
                                                      .primaryColorLight,
                                                  child: SizedBox(
                                                      height: dropDownCardHeight *
                                                          0.8,
                                                      child: Center(
                                                        child: DropdownButton<
                                                            String>(
                                                          value: selectedBhk
                                                              .toString(),
                                                          alignment: Alignment
                                                              .center,
                                                          elevation: 16,
                                                          underline: Container(),
                                                          onChanged: (
                                                              String? value) {
                                                            setState(() {
                                                              selectedBhk =
                                                                  int.parse(
                                                                      value!);
                                                            });
                                                          },
                                                          items: bhk
                                                              .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                                  (
                                                                  String value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Text(
                                                                      value,
                                                                      softWrap: true,
                                                                      style: TextStyle(
                                                                          fontSize: MyConst
                                                                              .smallTextSize *
                                                                              fontSizeScaleFactor,
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
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Select No. Of Floors',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: MyConst
                                                          .smallTextSize *
                                                          fontSizeScaleFactor,
                                                      fontWeight: FontWeight
                                                          .w500
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MyConst.deviceWidth(
                                                    context) * 0.010,
                                              ),
                                              Card(
                                                color: Get.isDarkMode ? Colors
                                                    .white12 : Theme
                                                    .of(context)
                                                    .primaryColorLight,
                                                child: SizedBox(
                                                    height: dropDownCardHeight *
                                                        0.8,
                                                    child: Center(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selectedFloor
                                                            .toString(),
                                                        alignment: Alignment
                                                            .center,
                                                        elevation: 16,
                                                        underline: Container(),
                                                        onChanged: (
                                                            String? value) {
                                                          setState(() {
                                                            selectedFloor =
                                                                int.parse(
                                                                    value!);
                                                          });
                                                        },
                                                        items: floor
                                                            .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                    value,
                                                                    softWrap: true,
                                                                    style: TextStyle(
                                                                        fontSize: MyConst
                                                                            .smallTextSize *
                                                                            fontSizeScaleFactor,
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
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Garden Availability',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      fontSize: MyConst
                                                          .smallTextSize *
                                                          fontSizeScaleFactor),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MyConst.deviceWidth(
                                                    context) * 0.010,
                                              ),
                                              Card(
                                                color: Get.isDarkMode ? Colors
                                                    .white12 : Theme
                                                    .of(context)
                                                    .primaryColorLight,
                                                child: SizedBox(
                                                    height: dropDownCardHeight *
                                                        0.8,
                                                    child: Center(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selectedGarden,
                                                        alignment: Alignment
                                                            .center,
                                                        elevation: 16,
                                                        underline: Container(),
                                                        onChanged: (
                                                            String? value) {
                                                          setState(() {
                                                            selectedGarden =
                                                            value!;
                                                          });
                                                        },
                                                        items: garden
                                                            .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                    value,
                                                                    softWrap: true,
                                                                    style: TextStyle(
                                                                        fontSize: MyConst
                                                                            .smallTextSize *
                                                                            fontSizeScaleFactor,
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
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Parking Facility',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      fontSize: MyConst
                                                          .smallTextSize *
                                                          fontSizeScaleFactor),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MyConst.deviceWidth(
                                                    context) * 0.010,
                                              ),
                                              Card(
                                                color: Get.isDarkMode ? Colors
                                                    .white12 : Theme
                                                    .of(context)
                                                    .primaryColorLight,
                                                child: SizedBox(
                                                    height: dropDownCardHeight *
                                                        0.8,
                                                    child: Center(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selectedParking,
                                                        alignment: Alignment
                                                            .center,
                                                        elevation: 16,
                                                        underline: Container(),
                                                        onChanged: (
                                                            String? value) {
                                                          setState(() {
                                                            selectedParking =
                                                            value!;
                                                          });
                                                        },
                                                        items: parking
                                                            .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                    value,
                                                                    softWrap: true,
                                                                    style: TextStyle(
                                                                        fontSize: MyConst
                                                                            .smallTextSize *
                                                                            fontSizeScaleFactor,
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
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Furnished Or Not',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      fontSize: MyConst
                                                          .smallTextSize *
                                                          fontSizeScaleFactor),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MyConst.deviceWidth(
                                                    context) * 0.010,
                                              ),
                                              Card(
                                                color: Get.isDarkMode ? Colors
                                                    .white12 : Theme
                                                    .of(context)
                                                    .primaryColorLight,
                                                child: SizedBox(
                                                    height: dropDownCardHeight *
                                                        0.8,
                                                    child: Center(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selectedFurnished,
                                                        alignment: Alignment
                                                            .center,
                                                        elevation: 16,
                                                        underline: Container(),
                                                        onChanged: (
                                                            String? value) {
                                                          setState(() {
                                                            selectedFurnished =
                                                            value!;
                                                          });
                                                        },
                                                        items: furnished
                                                            .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                    value,
                                                                    softWrap: true,
                                                                    style: TextStyle(
                                                                        fontSize: MyConst
                                                                            .smallTextSize *
                                                                            fontSizeScaleFactor,
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
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Available Or Not',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      fontSize: MyConst
                                                          .smallTextSize *
                                                          fontSizeScaleFactor),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MyConst.deviceWidth(
                                                    context) * 0.010,
                                              ),
                                              Card(
                                                color: Get.isDarkMode ? Colors
                                                    .white12 : Theme
                                                    .of(context)
                                                    .primaryColorLight,
                                                child: SizedBox(
                                                    height: dropDownCardHeight *
                                                        0.8,
                                                    child: Center(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selectedAvailability,
                                                        alignment: Alignment
                                                            .center,
                                                        elevation: 16,
                                                        underline: Container(),
                                                        onChanged: (
                                                            String? value) {
                                                          setState(() {
                                                            selectedAvailability =
                                                            value!;
                                                          });
                                                        },
                                                        items: available
                                                            .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                    value,
                                                                    softWrap: true,
                                                                    style: TextStyle(
                                                                        fontSize: MyConst
                                                                            .smallTextSize *
                                                                            fontSizeScaleFactor,
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
                                          const SizedBox(height: 20,),
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
                                            color: Get.isDarkMode ? Colors
                                                .white12 : Theme
                                                .of(context)
                                                .primaryColorLight,
                                            shadowColor: Colors.black,
                                            elevation: 2,
                                            child: TextField(
                                              onChanged: (value) {
                                                minPrice = int.parse(value);
                                              },
                                              controller: TextEditingController(
                                                  text: minPrice.toString()),
                                              keyboardType: TextInputType
                                                  .number,
                                              style: TextStyle(fontSize: MyConst
                                                  .smallTextSize *
                                                  fontSizeScaleFactor),
                                              textAlignVertical: TextAlignVertical
                                                  .center,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets
                                                    .only(bottom: 5),
                                                labelText: ' min price',
                                                labelStyle: TextStyle(
                                                    fontSize: MyConst
                                                        .smallTextSize *
                                                        fontSizeScaleFactor),
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
                                            color: Get.isDarkMode ? Colors
                                                .white12 : Theme
                                                .of(context)
                                                .primaryColorLight,
                                            shadowColor: Colors.black,
                                            elevation: 2,
                                            child: TextField(
                                              onChanged: (value) {
                                                maxPrice = int.parse(value);
                                              },
                                              controller:
                                              TextEditingController(
                                                  text: maxPrice.toString()),
                                              keyboardType: TextInputType
                                                  .number,
                                              style: TextStyle(fontSize: MyConst
                                                  .smallTextSize *
                                                  fontSizeScaleFactor),
                                              textAlignVertical: TextAlignVertical
                                                  .center,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets
                                                    .only(bottom: 5),
                                                labelText: ' max price',
                                                labelStyle: TextStyle(
                                                    fontSize: MyConst
                                                        .smallTextSize *
                                                        fontSizeScaleFactor),
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
                                        color: Get.isDarkMode
                                            ? Colors.white12
                                            : Theme
                                            .of(context)
                                            .primaryColorLight,
                                        shadowColor: Colors.black,
                                        elevation: 2,
                                        child: TextField(
                                          onChanged: (value) {
                                            selectedPropertyName = value;
                                          },
                                          controller: TextEditingController(
                                              text: selectedPropertyName),
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(
                                              fontSize: MyConst.smallTextSize *
                                                  fontSizeScaleFactor),
                                          textAlignVertical: TextAlignVertical
                                              .center,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets
                                                .only(bottom: 5),
                                            labelText: 'Filter By Name',
                                            labelStyle: TextStyle(
                                                fontSize: MyConst
                                                    .smallTextSize *
                                                    fontSizeScaleFactor),
                                            border: InputBorder.none,
                                            prefixIcon: Icon(Icons.search,
                                              size: MyConst.deviceHeight(
                                                  context) * 0.02,),
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
                                        color: Get.isDarkMode
                                            ? Colors.white12
                                            : Theme
                                            .of(context)
                                            .primaryColorLight,
                                        shadowColor: Colors.black,
                                        elevation: 2,
                                        child: TextField(
                                          onChanged: (value) {
                                            selectedCity = value;
                                          },
                                          controller:
                                          TextEditingController(
                                              text: selectedCity),
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(
                                              fontSize: MyConst.smallTextSize *
                                                  fontSizeScaleFactor),
                                          textAlignVertical: TextAlignVertical
                                              .center,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets
                                                .only(bottom: 5),
                                            labelText: 'Filter By City',
                                            labelStyle: TextStyle(
                                                fontSize: MyConst
                                                    .smallTextSize *
                                                    fontSizeScaleFactor),
                                            border: InputBorder.none,
                                            prefixIcon: const Icon(
                                                Icons.search),
                                          ),
                                          cursorOpacityAnimates: false,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10)
                                                  )
                                              ),
                                              onPressed: () {
                                                page = 1;
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
                                                selectedAvailability =
                                                "Available";
                                                selectedPropertyName = "";
                                                _hasNextPage = true;
                                                _isFirstLoadRunning = false;
                                                _firstLoad(appState,plcon);
                                                filterApplied = false;
                                                Navigator.pop(context);
                                                setTheState();
                                              },
                                              child: Text(
                                                'Clear Filter',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColorLight
                                                ),
                                              )),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: bluishClr,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10)
                                                  )
                                              ),
                                              onPressed: () {
                                                page = 1;
                                                _hasNextPage = true;
                                                _isFirstLoadRunning = false;
                                                _firstLoad(appState,plcon);
                                                filterApplied = true;
                                                Navigator.pop(context);
                                                setTheState();
                                              },
                                              child: Text(
                                                'Apply Filter',
                                                style: TextStyle(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColorLight,
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
    PropertyListController plcon = Get.find();
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return RefreshIndicator(
        color: bluishClr,
        onRefresh: () async {
          // setState(() {
          _isOfferLoading = false;
          _hasNextPage = true;
          page = 1;
          projectId = 1;
          _isFirstLoadRunning = false;
          _isLoadMoreRunning = false;
          _firstLoad(appState,plcon);
          appState.activeWidget = appState.activeWidget;
          //});
        },
        child: Container(
          child: Column(
            children: [
              //===========================FILTER ROW
              _filterContainer(appState,plcon),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.010,
              ),
              //==========================PROJECT ROW
              _projectRow(appState,plcon),
              //=====================================OFFER CONTAINER
             // _offerContainer(appState),
              SizedBox(
                height: MyConst.deviceHeight(context) * 0.02,
              ),
              //=====================================PROPERTY LIST CONTAINER
              _isFirstLoadRunning == false
                  ? appState.propertyList.isNotEmpty
                  ? _propertyListAnimation(appState, plcon)
                  : _emptyProperty()
                  : Container(
                margin: EdgeInsets.symmetric(
                    vertical: MyConst.deviceHeight(context) * 0.2),
                child:  Center(
                  child: StaticMethod.progressIndicator()
                ),
              ),
              //===================================LOADING MORE 
              _isLoadMoreRunning == true
                  ? StaticMethod.progressIndicator()
                  : Container(),
            ],
          ),
        ));
  }
  
  _filterContainer(appState,plcon){
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MyConst.deviceHeight(context) * 0.015),
      child: Row(
        children: [
          //=====================================FILTER BY NAME TEXT FIELD
          Flexible(
            child: Card(
              // color: Get.isDarkMode ? darkGreyClr : context.theme
              //     .primaryColorLight,
              color: Get.isDarkMode ? darkGreyClr : Colors.white,
              shadowColor: Colors.black.withOpacity(0.2),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0), // Circular border radius
              ),
              // shadowColor: Colors.grey.withOpacity(0.5), // Set a consistent shadow color
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0), // Circular border radius
                ),
                    child: TextField(
                      onChanged: (value) {
                        selectedPropertyName = value;
                        _hasNextPage = true;
                        page = 1;
                        //setState(() {
                        _isFirstLoadRunning = false;
                        _firstLoad(appState,plcon);
                        //});
                      },
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          fontSize: MyConst.mediumSmallTextSize,),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 5),
                        labelText: 'Filter By Name',
                        labelStyle: const TextStyle(fontSize: MyConst
                            .smallTextSize,),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search,
                          size: MyConst.deviceHeight(context) * 0.025,),
                      ),
                      cursorOpacityAnimates: false,
                    ),
              ),
            ),
          ),
          SizedBox(width: MyConst.deviceWidth(context) * 0.010,),
          //=====================================FILTER BTN
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MyConst.deviceHeight(context) * 0.045,
                    width: MyConst.deviceHeight(context) * 0.045,
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Colors.white10
                            : Colors.white,
                        border: Border.all(
                            width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/Icons/filter.png',
                        color: Get.isDarkMode
                            ? Colors.white70
                            : Colors.black,
                        height: MyConst.deviceHeight(context) * 0.045,
                        width: MyConst.deviceHeight(context) * 0.045,
                      ),
                      onPressed: () {
                        //selectedPropertyType = "All";
                        _showFilterContainer(appState,plcon, context);
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
    );
  }
  
  _projectRow(appState,plcon){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: _isProjectLoading
          ? Center(child:Container())
          : projectList.isNotEmpty
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('Under The Project',
          //     style: titleStyle
          // ),
          Text('Buildcon Projects',
              style: titleStyle
          ),
          const Spacer(),
          Card(
              color: Get.isDarkMode ? Colors.white10 : Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0), // Circular border radius
              ),

              child: Container(
                height: 30,
                // margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: DropdownButton<String>(
                  value: selectedName.isEmpty
                      ? projectList[0]['project_name']
                      : selectedName,
                  alignment: Alignment.center,
                  elevation: 16,
                  underline: Container(),
                  onChanged: (value) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedName = value!;
                      projectId = projectList.firstWhere((element) =>
                      element['project_name'] == value)['project_id']
                          .toInt();
                      //print(projectId);
                      _mounted = true;
                      _hasNextPage = true;
                      page = 1;
                      _isFirstLoadRunning = false;
                      _isLoadMoreRunning = false;
                      _firstLoad(appState,plcon);
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
                              style: const TextStyle(
                                  fontSize: MyConst.smallTextSize,
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
    );
  }
  
  _offerContainer(appState){
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery
              .of(context)
              .size
              .height * 0.015,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        child: _isOfferLoading
            ? Shimmer.fromColors(
            baseColor: Theme
                .of(context)
                .primaryColor,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
              ),
            )
        )
            : appState.offerList.isNotEmpty
            ? const OfferSlider()
            : Container()
    );
  }
  
  _propertyListAnimation(appState,plcon){
    return Container(child: Flexible(
        child: Obx((){
          return ListView.builder(
            itemCount: controller.propertyList.length,
            controller: _controller,
            itemBuilder: (context, index) {
              PropertyList property = controller.propertyList[index];
              double propertyRating = 0.0;
              int totalRating = int.parse(property.total_rating!);
              int totalReview = property.review_count!;
              if (totalRating != 0) {
                propertyRating = totalRating / totalReview;
              }
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 100,
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {
                          //print(property['property_id']);
                          appState.p_id = property.property_id!;
                          appState.activeWidget = "PropertyDetailPage";
                          controller.appBarContent.value = 'Property Details';
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.010,
                              vertical: 8,
                            ),
                            child: Card(
                              color: Get.isDarkMode ? darkGreyClr : Colors
                                  .white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 8,
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
          );
        })
    ),);
  }

  _propertyImage(PropertyList property) {
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
            child: property.pi_name!.isNotEmpty
                ? CachedNetworkImage(
              imageUrl:
              '${ApiLinks.accessPropertyImages}/${property.pi_name![0]}',
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

  _propertyDetail(PropertyList property, propertyRating) {
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
                property.property_name!.toUpperCase(),
                style: const TextStyle(
                  fontSize: MyConst.smallTextSize,
                  fontWeight: FontWeight.w600,
                ),
                softWrap: true,
              ),

              //=======================AREA TEXT
              Text(
                '${property.property_area}  ${property.property_areaUnit}',
                softWrap: true,
                style: const TextStyle(
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
                      '${property.property_price}',
                      style: const TextStyle(
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
                        '${property.property_locality}, ${property.property_city}',
                        style: const TextStyle(
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
                      '(${property.review_count})',
                      style: const TextStyle(
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

  _emptyProperty() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 150,),
        Center(child: Text(
          'No Such Properties',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: MyConst.largeTextSize,
          ),
        ),)
      ],
    );
  }
  
}
