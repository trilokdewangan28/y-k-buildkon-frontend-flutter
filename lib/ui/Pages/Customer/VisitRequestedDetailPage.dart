import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/ui/Pages/ImagePickerPage.dart';
import 'package:real_state/ui/Pages/Offer/AddOfferPage.dart';
import 'package:real_state/ui/Pages/Property/ImageSlider.dart';
import 'package:real_state/ui/Pages/StaticContentPage/AdminContactPage.dart';

import 'package:real_state/ui/Widgets/Other/RatingDisplayWidgetTwo.dart';

class VisitRequestedDetailPage extends StatefulWidget {
  int visitid;
  VisitRequestedDetailPage({Key? key, required this.visitid}) : super(key: key);

  @override
  State<VisitRequestedDetailPage> createState() =>
      _VisitRequestedDetailPageState();
}

class _VisitRequestedDetailPageState extends State<VisitRequestedDetailPage> {
  bool _mouted = false;
  bool _isPropertyLoading = false;
  Map<String,dynamic> visitDetails = {};
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  final DateTime lastSelectableDate =
  DateTime.now().add(const Duration(days: 365));
  final DateTime firstSelectableDate =
  DateTime.now().add(const Duration(days: 1));
  final _visitingDateController = TextEditingController();
  final _visitorNameController = TextEditingController();
  final _visitorNumberController = TextEditingController();
  final _employeeRefNoController = TextEditingController();

  final FocusNode _visitingDateFocusNode = FocusNode();
  final FocusNode _visitorNameFocusNode = FocusNode();
  final FocusNode _visitorNumberFocusNode = FocusNode();
  final FocusNode _employeeRefNoFocusNode = FocusNode();

  bookVisit(requestData, appState, context) async {
    var url = Uri.parse(ApiLinks.requestVisit);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>  Center(
        child:StaticMethod.progressIndicator()
      ),
    );
    final res = await StaticMethod.requestVisit(appState.token, requestData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  addToFavorite(data, appState, context) async {
    var url = Uri.parse(ApiLinks.addToFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>  Center(
        child:StaticMethod.progressIndicator()
      ),
    );
    final res = await StaticMethod.addToFavorite(appState.token, data, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        fetchFavoriteProperty(appState);
        if(_mouted){
          setState(() {});
        }
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  removeFromFavorite(data, appState, context) async {
    var url = Uri.parse(ApiLinks.removeFromFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Center(
        child:StaticMethod.progressIndicator()
      ),
    );
    final res = await StaticMethod.removeFromFavorite(appState.token,data, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        fetchFavoriteProperty(appState);
        if(_mouted){
          setState(() {});
        }
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  fetchFavoriteProperty(appState) async {
    var data = {
      "c_id": appState.customerDetails['customer_id'],
      "p_id": appState.selectedProperty['property_id']
    };
    var url = Uri.parse(ApiLinks.fetchFavoriteProperty);
    final res = await StaticMethod.fetchFavoriteProperty(appState.token, data, url);
    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print(res);
        if (res['result'].length > 0) {
          appState.addedToFavorite = true;
          if(_mouted){
            setState(() {});
          }
        } else {
          appState.addedToFavorite = false;
          if(_mouted){
            setState(() {});
          }
        }
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
      } else {
        appState.addedToFavorite = false;
        if(_mouted){
          setState(() {});
        }
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //===================================SUBMIT PROPERTY RATING
  submitPropertyRating(data, appState, btmSheetContext) async {
    var url = Uri.parse(ApiLinks.submitPropertyRating);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Center(
        child:StaticMethod.progressIndicator()
      ),
    );

    final response = await StaticMethod.submitPropertyRating(appState.token, data, url);
    Navigator.pop(context);
    if (response.isNotEmpty) {
      if (response['success'] == true) {
        Navigator.pop(btmSheetContext);
        StaticMethod.showDialogBar(response['message'], Colors.green);
      } else {
        Navigator.pop(btmSheetContext);
        StaticMethod.showDialogBar(response['message'], Colors.red);
      }
    }
  }

  //===================================SUBMIT FEEDBACK & RATING BTMST
  void _showBottomSheetForSubmitRating(BuildContext context, appState) {
    final feedbackController = TextEditingController();
    int rateValue = 0;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                  child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ?darkGreyClr : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Text(
                      'select your rating',
                      style: titleStyle
                    ),
                    //--------------------------------------------RATING CONTAINER
                    Container(
                        margin: const EdgeInsets.all(15),
                        padding:
                            const EdgeInsets.only(top: 8, left: 16, right: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    rateValue = 1;
                                  });
                                  //print(rateValue);
                                },
                                icon: rateValue >= 1
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.star_border_outlined)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    rateValue = 2;
                                  });
                                  //print(rateValue);
                                },
                                icon: rateValue >= 2
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.star_border_outlined)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    rateValue = 3;
                                  });
                                  //print(rateValue);
                                },
                                icon: rateValue >= 3
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.star_border_outlined)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    rateValue = 4;
                                  });
                                  //print(rateValue);
                                },
                                icon: rateValue >= 4
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.star_border_outlined)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    rateValue = 5;
                                  });
                                  //print(rateValue);
                                },
                                icon: rateValue == 5
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.star_border_outlined)),
                          ],
                        )),
                    //---------------------------------------FEEDBACK CONTAINER
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextField(
                        controller: feedbackController,
                        maxLines: null,
                        // Allows an unlimited number of lines
                        decoration: InputDecoration(
                          labelText: 'Enter your feedback...',
                          hintText: 'Enter your feedback here...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                    //--------------------------------------------------SUBMIT NOW
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bluishClr,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                        onPressed: () {
                          var data = {
                            "c_id": appState.customerDetails['customer_id'],
                            "p_id": appState.selectedProperty['property_id'],
                            "feedback": feedbackController.text,
                            "rating": rateValue
                          };
                          _mouted=true;
                          submitPropertyRating(data, appState, context);
                        },
                        child: Text('submit',style: TextStyle(color: Colors.white),))
                  ],
                ),
              ));
            }));
  }

  //=================================================================DATE PICKER
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstSelectableDate,
        lastDate: lastSelectableDate);

    if (picked != null && picked != selectedDate) {
      if(_mouted){
        setState(() {
          selectedDate = picked;
          _visitingDateController.text =
          '${selectedDate.toLocal()}'.split(' ')[0];
        });
      }
    }
  }


  //=================================================SHOW VISIT DETAIL CONTAINER
  void _showVisitDetailContainer(appState, pageContext) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
                child: Container(
                    color: Theme.of(context).primaryColorLight,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewInsets.top + 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          //===================================VISITOR NAME TEXTFIELD
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: TextFormField(
                                controller: _visitorNameController,
                                focusNode: _visitorNameFocusNode,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Visitors Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'should not be empty';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //===================================VISITOR NUMBER TEXTFIELD
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: TextFormField(
                                controller: _visitorNumberController,
                                focusNode: _visitorNumberFocusNode,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Visitors Mobile Number',
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'should not be empty';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //===================================VISITING DATE TEXTFIELD
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: TextFormField(
                                controller: _visitingDateController,
                                focusNode: _visitingDateFocusNode,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Vising Date',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder()),
                                onTap: (){
                                  _mouted=true;
                                  _selectDate(context);
                                },
                                readOnly: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'date should not be empty';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //===================================EMPLOYEE REFERENCE NUMBER TEXTFIELD
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: TextField(
                              controller: _employeeRefNoController,
                              focusNode: _employeeRefNoFocusNode,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText:
                                  'Employee Reference Number ( optional )',
                                  border: OutlineInputBorder()),
                            ),
                          ),

                          //====================================SUBMIT BTN
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Theme.of(context).primaryColor),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    var visitData = {
                                      "visitor_name":
                                      _visitorNameController.text,
                                      "visitor_number":
                                      _visitorNumberController.text,
                                      "employee_un":
                                      _employeeRefNoController.text ?? "",
                                      "v_date": _visitingDateController.text,
                                      "c_id": appState
                                          .customerDetails['customer_id'],
                                      "p_id": appState
                                          .selectedProperty['property_id']
                                    };
                                    _mouted=true;
                                    bookVisit(visitData, appState, pageContext);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorLight),
                                )),
                          )
                        ],
                      ),
                    )));
          },
        );
      },
    );
  }

  //=================================================CANCEL REQUEST
  _changeVisitStatus(data,appState,context)async{
    var url = Uri.parse(ApiLinks.cancelVisitRequest);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>  Center(
        child:StaticMethod.progressIndicator()
      ),
    );
    final res = await StaticMethod.changeVisitStatus(appState.token,data,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget = "VisitRequestedListWidget";
      }else{
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }


  int totalRating = 0;
  int totalReview = 0;
  double propertyRating = 0.0;
  //=====================================================FETCH SINGLE PROPERTY
  _fetchSingleVisitRequest(appState)async{
    if(_mouted){
      setState(() {
        _isPropertyLoading = true;
      });
    }
    var data = {
      "v_id":widget.visitid,
      "c_id":appState.customerDetails['customer_id']
    };
    var url = Uri.parse(ApiLinks.fetchVisitRequestedPropertyDetails);
    final res = await StaticMethod.fetchVisitRequestedPropertyDetails(appState.token,data, url);
    print(res);
    if(res.isNotEmpty){
      if(res['success']==true){
        if(res['result'].length!=0){
          if(_mouted){
            setState(() {
              visitDetails = res['result'];
              print(visitDetails);
              appState.selectedProperty = res['result'];
              //print(selectedProperty);
              totalRating = int.parse(visitDetails['total_rating']);
              totalReview = visitDetails['review_count'];
              if(totalRating>0){
                propertyRating = totalRating/totalReview;
              }
            });
          }
        }else {
          if(_mouted){
            setState(() {
              visitDetails = {};
              _isPropertyLoading=false;
            });
          }
        }
        if(_mouted){
          setState(() {
            _isPropertyLoading=false;
          });
        }
      }else{
        // display some another widget for message
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
          _mouted=true;
          _fetchSingleVisitRequest(appState);
        });
      }
    }
    _mouted=true;
    await fetchFavoriteProperty(appState);
  }

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    _mouted=true;
    _fetchSingleVisitRequest(appState);
    fetchFavoriteProperty(appState);
    super.initState();
  }
  @override
  void dispose() {
    _mouted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return PopScope(
      canPop: true,
        onPopInvoked: (didPop) {
          appState.selectedProperty={};
          appState.activeWidget = "VisitRequestedListPage";
          appState.addedToFavorite = false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0.0,
            title: Text('Visit Details'),
          ),
          body: _isPropertyLoading 
              ? Center(
            child: SpinKitThreeBounce(size: 20,color: primaryColor,),
          )
              : Container(
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //===========================PROPERTY IMAGES
                  Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  child:
                                  appState.selectedProperty['pi_name'].length>0
                                      ? Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: ImageSlider(
                                      propertyData:
                                      appState.selectedProperty,
                                      asFinder: true,
                                    ),
                                  )
                                      : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Get.isDarkMode? Colors.white12 : Theme.of(context).primaryColorLight,
                                          border: Border.all(width: 1),
                                          borderRadius:
                                          BorderRadius.circular(25)),
                                      child: Image.asset('assets/images/home.jpg', height: 150,)
                                  )),
                            ],
                          )),
                      appState.userType == 'admin'
                          ? Positioned(
                          bottom: 25,
                          right: 25,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImagePickerPage(
                                            userDetails:
                                            appState.selectedProperty,
                                            forWhich: 'propertyImage',
                                          )));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColorLight,
                                )),
                          ))
                          : Container()
                    ],
                  ),

                  //===========================PROPERTY DETAIL SECTION
                  //================================== ROW 1
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      children: [
                        //================================NAME
                        Expanded(
                          child: Text(
                            '${appState.selectedProperty['property_name'].toUpperCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                              MyConst.mediumSmallTextSize * fontSizeScaleFactor,
                            ),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),

                        //================================RATINGS
                        InkWell(
                            onTap: appState.userType == 'customer'
                                ? () {
                              _showBottomSheetForSubmitRating(
                                  context, appState);
                            }
                                : null,
                            child: RatingDisplayWidgetTwo(
                                rating: appState.selectedProperty['property_rating']
                                    .toDouble())),
                        //================================RATING USER COUNT
                        Text(
                          '(${appState.selectedProperty['property_ratingCount']})',
                          style: TextStyle(
                              fontSize: MyConst.smallTextSize * fontSizeScaleFactor),
                        )
                      ],
                    ),
                  ),

                  //==================================ROW 2
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Row(
                      children: [
                        //============================LOCATION
                        Icon(
                          Icons.location_pin,
                          color: Get.isDarkMode?Colors.white70 : Theme.of(context).primaryColor,
                          size: MyConst.mediumTextSize * fontSizeScaleFactor,
                        ),
                        Expanded(
                          child: Text(
                            '${appState.selectedProperty['property_address']}, ${appState.selectedProperty['property_locality']} , ${appState.selectedProperty['property_city']}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                MyConst.smallTextSize * fontSizeScaleFactor),
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),

                  //==================================ROW 3
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      children: [
                        //============================PRICE ICON
                        Icon(
                          Icons.currency_rupee,
                          color: Get.isDarkMode?Colors.white70: Theme.of(context).primaryColor,
                          size: MyConst.mediumTextSize * fontSizeScaleFactor,
                        ),
                        //=============================PRICE
                        Text(
                          '${appState.selectedProperty['property_price']}',
                          style: TextStyle(
                              fontSize: MyConst.smallTextSize * fontSizeScaleFactor,
                              fontWeight: FontWeight.w700,
                              color: Get.isDarkMode?Colors.white60 :Theme.of(context).primaryColor
                          ),
                        ),
                        const Spacer(),
                        //=============================FAVRITE BTN
                        appState.userType == 'customer'
                            ? IconButton(
                            onPressed: appState.userType == 'customer'
                                ? () {
                              if (appState.customerDetails.isNotEmpty) {
                                //print(appState.customerDetails);
                                var data = {
                                  "c_id": appState
                                      .customerDetails['customer_id'],
                                  "p_id": appState
                                      .selectedProperty['property_id']
                                };

                                appState.addedToFavorite == false
                                    ? addToFavorite(data, appState, context)
                                    : removeFromFavorite(
                                    data, appState, context);
                              } else {
                                StaticMethod.showDialogBar('You have to login, please login', Colors.red);
                              }
                            }
                                : null,
                            icon: appState.addedToFavorite == false
                                ? const Icon(Icons.favorite_outline)
                                : const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ))
                            : Container(),
                      ],
                    ),
                  ), //-----------price
                  const SizedBox(
                    height: 10,
                  ),

                  //=================================ROW 4
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1,color: Get.isDarkMode?Colors.white70:Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          //-----------------------------type and area
                          Row(
                            children: [
                              //=========================type container
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Type',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: MyConst.smallTextSize *
                                              fontSizeScaleFactor),
                                    ),
                                    Icon(
                                      Icons.home_work_outlined,
                                      color: Get.isDarkMode ? Colors.white70: Theme.of(context).primaryColor,
                                      size: MyConst.mediumLargeTextSize *
                                          fontSizeScaleFactor,
                                    ),
                                    Text(
                                      '${appState.selectedProperty['property_type']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: MyConst.smallTextSize *
                                              fontSizeScaleFactor,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              //=========================area container
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Area',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: MyConst.smallTextSize *
                                              fontSizeScaleFactor),
                                    ),
                                    Icon(
                                      Icons.square_foot_outlined,
                                      color: Get.isDarkMode ? Colors.white70: Theme.of(context).primaryColor,
                                      size: MyConst.mediumLargeTextSize *
                                          fontSizeScaleFactor,
                                    ),
                                    Text(
                                      '${appState.selectedProperty['property_area']} ${appState.selectedProperty['property_areaUnit']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: MyConst.smallTextSize *
                                              fontSizeScaleFactor,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //-----------------------------bhk and furnished
                          appState.selectedProperty['property_type'] == 'House' ||
                              appState.selectedProperty['property_type'] == 'Flat'
                              ? Row(
                            children: [
                              //==========================BHK CONTAINER
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'BHK',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.bedroom_parent_outlined,
                                      color: Get.isDarkMode ? Colors.white70: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      '${appState.selectedProperty['property_bhk']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              //==========================FURNISHED CONTAINER
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Furnished',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.chair_outlined,
                                      color: Get.isDarkMode ? Colors.white70: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      '${appState.selectedProperty['property_isFurnished']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                              : Container(),

                          const SizedBox(
                            height: 20,
                          ),

                          //---------------------------garden and parking
                          appState.selectedProperty['property_type'] == 'House'
                              ? Row(
                            children: [
                              //==============================garden container
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Garden',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.park_outlined,
                                      color: Get.isDarkMode ? Colors.white70: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      '${appState.selectedProperty['property_isGarden']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              //==============================parking container
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Parking',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.local_parking_outlined,
                                      color: Get.isDarkMode ? Colors.white70: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      '${appState.selectedProperty['property_isParking']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                              : Container(),
                        ],
                      )),
                  const SizedBox(
                    width: 20,
                  ),

                  //==========================================PROPERTY DESCRIPTION
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: const Text(
                      'About Property',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Text(
                      '${appState.selectedProperty['property_desc']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.grey),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //==========================================LOCATION MAP
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: const Text(
                      'Location',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: InkWell(
                        highlightColor: Theme.of(context).primaryColorDark,
                        onTap: () {
                          //print('map url is ${appState.selectedProperty['p_locationUrl']}');
                          StaticMethod.openMap(
                              appState.selectedProperty['property_locationUrl']);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/images/map.jpg',
                            fit: BoxFit.cover,
                            height: 100,
                            width: double.infinity,
                          ),
                        ),
                      )),

                  //===========================================BUTTONS
                  appState.userType == 'customer'
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.37,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bluishClr,
                                foregroundColor:
                                Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            onPressed: () {
                              _showVisitDetailContainer(appState, context);
                            },
                            child: Text(
                              'Request Visit',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight),
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.37,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: bluishClr,
                                  foregroundColor: Theme.of(context).primaryColorLight,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              onPressed: () {
                                //Navigator.pop(context);
                                Get.to(()=>AdminContactPage());
                                appState.currentState = 0;
                              },
                              child: Text(
                                'Contact Now',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                              ))),
                    ],
                  )
                      : Container(),
                  appState.userType == 'customer'
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.37,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bluishClr,
                                foregroundColor:
                                Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            onPressed: () {
                              // _showVisitDetailContainer(appState, context);
                            },
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight),
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.37,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Theme.of(context).primaryColorLight,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              onPressed: appState.selectedProperty['v_status']==0
                                  ? () {
                                var data = {
                                  "newStatus":3,
                                  "c_id":appState.customerDetails['customer_id'],
                                  "p_id":appState.selectedProperty['property_id'],
                                  "v_id":appState.selectedProperty['v_id']
                                };
                                _changeVisitStatus(data, appState, context);
                              }
                                  : null,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                              ))),
                    ],
                  )
                      : Container(),

                  // //=======================================OFFER RELATED ROW
                  // Container(
                  //   height: MyConst.deviceHeight(context)*0.3,
                  //   width: MyConst.deviceWidth(context),
                  //   margin: EdgeInsets.symmetric(horizontal: 15),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(width: 1),
                  //     borderRadius: BorderRadius.circular(10)
                  //   ),
                  //   child: Text('offer here'),
                  // ),
                  Center(
                    child: appState.userType == 'admin'
                        ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddOfferPage(
                                    p_id: appState
                                        .selectedProperty['property_id'],
                                    forWhich: "offerImage",
                                  )));
                        },
                        child: Text(
                          'Add Offers',
                          style:
                          TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: FontWeight.w600
                          ),
                        )
                    )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
