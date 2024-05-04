// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:real_state/controller/MyProvider.dart';
// import 'package:real_state/config/ApiLinks.dart';
// import 'package:real_state/config/Constant.dart';
// import 'package:real_state/config/StaticMethod.dart';
// import 'package:real_state/services/ThemeService/theme.dart';
// import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
// import 'package:real_state/ui/Pages/ImagePickerPage.dart';
// import 'package:real_state/ui/Pages/Offer/AddOfferPage.dart';
// import 'package:real_state/ui/Pages/Property/ImageSlider.dart';
// import 'package:real_state/ui/Pages/Property/PropertyDetailPage.dart';
//
// import 'package:real_state/ui/Widgets/Other/RatingDisplayWidgetTwo.dart';
//
// import '../../Pages/StaticContentPage/AdminContactPage.dart';
//
// class ProjectPropertyDetail extends StatefulWidget {
//   const ProjectPropertyDetail({Key? key}) : super(key: key);
//
//   @override
//   State<ProjectPropertyDetail> createState() => _ProjectPropertyDetailState();
// }
//
// class _ProjectPropertyDetailState extends State<ProjectPropertyDetail> {
//
//   bool _mounted = false;
//   final _formKey = GlobalKey<FormState>();
//
//   //===========================================DATE VARIABLE
//   DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
//   final DateTime lastSelectableDate =
//   DateTime.now().add(const Duration(days: 365));
//   final DateTime firstSelectableDate =
//   DateTime.now().add(const Duration(days: 1));
//
//
//   final _visitingDateController = TextEditingController();
//   final _visitorNameController = TextEditingController();
//   final _visitorNumberController = TextEditingController();
//   final _employeeRefNoController = TextEditingController();
//
//   final FocusNode _visitingDateFocusNode = FocusNode();
//   final FocusNode _visitorNameFocusNode = FocusNode();
//   final FocusNode _visitorNumberFocusNode = FocusNode();
//   final FocusNode _employeeRefNoFocusNode = FocusNode();
//
//   bool _isOfferLoading = false;
//   bool _isPropertyLoading=false;
//   Map<String,dynamic> offer = {};
//
//   List<String> available = ['Sold','Not Available','Available'];
//   String selectedAvailability='Sold';
//   Color availabilityColor = Colors.orange;
//
//   //===========================================RATING VARIABLE
//   Map<String,dynamic> selectedProperty = {};
//   double propertyRating = 0.0;
//   int totalRating = 0;
//   int totalReview = 0;
//   //
//   // //==================================================================BOOK VISIT
//   // bookVisit(requestData, appState, context) async {
//   //   var url = Uri.parse(ApiLinks.requestVisit);
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (dialogContext) => const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   );
//   //   final res =
//   //   await StaticMethod.requestVisit(appState.token, requestData, url);
//   //   if (res.isNotEmpty) {
//   //     Navigator.pop(context);
//   //     if (res['success'] == true) {
//   //       StaticMethod.showDialogBar(res['message'], Colors.green);
//   //     } else {
//   //       StaticMethod.showDialogBar(res['message'], Colors.red);
//   //     }
//   //   }
//   // }
//   //
//   // //==================================================================CHANGE PROPERTY AVAILABILITY
//   // changePropertyAvailability(data, appState, context) async {
//   //   _mounted=true;
//   //   var url = Uri.parse(ApiLinks.changePropertyAvailability);
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (dialogContext) => const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   );
//   //   final res =
//   //   await StaticMethod.changePropertyAvailability(appState.token, data, url);
//   //   if (res.isNotEmpty) {
//   //     Navigator.pop(context);
//   //     if (res['success'] == true) {
//   //       StaticMethod.showDialogBar(res['message'], Colors.green);
//   //       appState.activeWidget=appState.activeWidget;
//   //       _isPropertyLoading=false;
//   //       _isOfferLoading=false;
//   //       _loadOffer(appState);
//   //       _fetchSingleProperty(appState);
//   //     } else {
//   //       StaticMethod.showDialogBar(res['message'], Colors.red);
//   //     }
//   //   }
//   // }
//   //
//   // //=============================================================ADD TO FAVORITE
//   // addToFavorite(data, appState, context) async {
//   //   var url = Uri.parse(ApiLinks.addToFavorite);
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (dialogContext) => const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   );
//   //   final res = await StaticMethod.addToFavorite(data['token'], data, url);
//   //   if (res.isNotEmpty) {
//   //     Navigator.pop(context);
//   //     if (res['success'] == true) {
//   //       StaticMethod.showDialogBar(res['message'], Colors.green);
//   //       fetchFavoriteProperty(appState);
//   //       if(_mounted){
//   //         setState(() {});
//   //       }
//   //     } else {
//   //       StaticMethod.showDialogBar(res['message'], Colors.red);
//   //     }
//   //   }
//   // }
//   //
//   // //========================================================REMOVE FROM FAVORITE
//   // removeFromFavorite(data, appState, context) async {
//   //   var url = Uri.parse(ApiLinks.removeFromFavorite);
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (dialogContext) => const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   );
//   //   final res =
//   //   await StaticMethod.removeFromFavorite(appState.token, data, url);
//   //   if (res.isNotEmpty) {
//   //     Navigator.pop(context);
//   //     if (res['success'] == true) {
//   //       StaticMethod.showDialogBar(res['message'], Colors.green);
//   //       fetchFavoriteProperty(appState);
//   //       if(_mounted){
//   //         setState(() {});
//   //       }
//   //     } else {
//   //       StaticMethod.showDialogBar(res['message'], Colors.red);
//   //     }
//   //   }
//   // }
//   //
//   // //=====================================================FETCH FAVORITE PROPERTY
//   // fetchFavoriteProperty(appState) async {
//   //   var data = {
//   //     "c_id": appState.customerDetails['customer_id'],
//   //     "p_id": selectedProperty['property_id']
//   //   };
//   //   var url = Uri.parse(ApiLinks.fetchFavoriteProperty);
//   //   final res =
//   //   await StaticMethod.fetchFavoriteProperty(appState.token, data, url);
//   //   if (res.isNotEmpty) {
//   //     if (res['success'] == true) {
//   //       //print(res);
//   //       if (res['result'].length > 0) {
//   //         appState.addedToFavorite = true;
//   //         if(_mounted){
//   //           setState(() {});
//   //         }
//   //       } else {
//   //         appState.addedToFavorite = false;
//   //         if(_mounted){
//   //           setState(() {});
//   //         }
//   //       }
//   //       //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
//   //     } else {
//   //       appState.addedToFavorite = false;
//   //       if(_mounted){
//   //         setState(() {});
//   //       }
//   //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
//   //     }
//   //   }
//   // }
//   //
//   // //======================================================SUBMIT PROPERTY RATING
//   // submitPropertyRating(data, appState, btmSheetContext) async {
//   //   var url = Uri.parse(ApiLinks.submitPropertyRating);
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (dialogContext) => const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   );
//   //
//   //   final response =
//   //   await StaticMethod.submitPropertyRating(appState.token, data, url);
//   //   Navigator.pop(context);
//   //   if (response.isNotEmpty) {
//   //     if (response['success'] == true) {
//   //       Navigator.pop(btmSheetContext);
//   //       StaticMethod.showDialogBar(response['message'], Colors.green);
//   //       _isPropertyLoading=false;
//   //       _fetchSingleProperty(appState);
//   //     } else {
//   //       Navigator.pop(btmSheetContext);
//   //       StaticMethod.showDialogBar(response['message'], Colors.red);
//   //     }
//   //   }
//   // }
//   //
//   // //==============================================SUBMIT FEEDBACK & RATING BTMST
//   // void _showBottomSheetForSubmitRating(BuildContext context, appState) {
//   //   final feedbackController = TextEditingController();
//   //   int rateValue = 0;
//   //   showModalBottomSheet(
//   //       backgroundColor: Colors.transparent,
//   //       context: context,
//   //       isScrollControlled: true,
//   //       useSafeArea: true,
//   //       builder: (BuildContext context) =>
//   //           StatefulBuilder(builder: (context, setState) {
//   //             return SingleChildScrollView(
//   //                 child: Container(
//   //                   margin: const EdgeInsets.symmetric(horizontal: 15),
//   //                   padding: EdgeInsets.only(
//   //                       bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
//   //                   decoration: BoxDecoration(
//   //                       color: Get.isDarkMode?darkGreyClr:Colors.white,
//   //                       borderRadius: BorderRadius.only(
//   //                           topLeft: Radius.circular(20),
//   //                           topRight: Radius.circular(20))),
//   //                   child: Column(
//   //                     children: [
//   //                       const Text(
//   //                         'select your rating',
//   //                         style: TextStyle(
//   //                             fontSize: 16,
//   //                             fontWeight: FontWeight.bold),
//   //                       ),
//   //                       //--------------------------------------------RATING CONTAINER
//   //                       Container(
//   //                           margin: const EdgeInsets.all(15),
//   //                           padding:
//   //                           const EdgeInsets.only(top: 8, left: 16, right: 16),
//   //                           child: Row(
//   //                             crossAxisAlignment: CrossAxisAlignment.center,
//   //                             mainAxisAlignment: MainAxisAlignment.center,
//   //                             children: [
//   //                               IconButton(
//   //                                   onPressed: () {
//   //                                     setState(() {
//   //                                       rateValue = 1;
//   //                                     });
//   //                                     //print(rateValue);
//   //                                   },
//   //                                   icon: rateValue >= 1
//   //                                       ? const Icon(
//   //                                     Icons.star,
//   //                                     color: Colors.green,
//   //                                   )
//   //                                       : const Icon(Icons.star_border_outlined)),
//   //                               IconButton(
//   //                                   onPressed: () {
//   //                                     setState(() {
//   //                                       rateValue = 2;
//   //                                     });
//   //                                     //print(rateValue);
//   //                                   },
//   //                                   icon: rateValue >= 2
//   //                                       ? const Icon(
//   //                                     Icons.star,
//   //                                     color: Colors.green,
//   //                                   )
//   //                                       : const Icon(Icons.star_border_outlined)),
//   //                               IconButton(
//   //                                   onPressed: () {
//   //                                     setState(() {
//   //                                       rateValue = 3;
//   //                                     });
//   //                                     //print(rateValue);
//   //                                   },
//   //                                   icon: rateValue >= 3
//   //                                       ? const Icon(
//   //                                     Icons.star,
//   //                                     color: Colors.green,
//   //                                   )
//   //                                       : const Icon(Icons.star_border_outlined)),
//   //                               IconButton(
//   //                                   onPressed: () {
//   //                                     setState(() {
//   //                                       rateValue = 4;
//   //                                     });
//   //                                     //print(rateValue);
//   //                                   },
//   //                                   icon: rateValue >= 4
//   //                                       ? const Icon(
//   //                                     Icons.star,
//   //                                     color: Colors.green,
//   //                                   )
//   //                                       : const Icon(Icons.star_border_outlined)),
//   //                               IconButton(
//   //                                   onPressed: () {
//   //                                     setState(() {
//   //                                       rateValue = 5;
//   //                                     });
//   //                                     //print(rateValue);
//   //                                   },
//   //                                   icon: rateValue == 5
//   //                                       ? const Icon(
//   //                                     Icons.star,
//   //                                     color: Colors.green,
//   //                                   )
//   //                                       : const Icon(Icons.star_border_outlined)),
//   //                             ],
//   //                           )),
//   //                       //---------------------------------------FEEDBACK CONTAINER
//   //                       Container(
//   //                         margin: const EdgeInsets.all(15),
//   //                         child: TextField(
//   //                           controller: feedbackController,
//   //                           maxLines: null,
//   //                           // Allows an unlimited number of lines
//   //                           decoration: InputDecoration(
//   //                             labelText: 'Enter your feedback...',
//   //                             hintText: 'Enter your feedback here...',
//   //                             border: OutlineInputBorder(
//   //                                 borderRadius: BorderRadius.circular(15)),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       //--------------------------------------------------SUBMIT NOW
//   //                       ElevatedButton(
//   //                         style: ElevatedButton.styleFrom(
//   //                           backgroundColor: bluishClr,
//   //                           shape: RoundedRectangleBorder(
//   //                             borderRadius: BorderRadius.circular(10)
//   //                           )
//   //                         ),
//   //                           onPressed: () {
//   //                             var data = {
//   //                               "c_id": appState.customerDetails['customer_id'],
//   //                               "p_id": selectedProperty['property_id'],
//   //                               "feedback": feedbackController.text,
//   //                               "rating": rateValue
//   //                             };
//   //                             _mounted=true;
//   //                             submitPropertyRating(data, appState, context);
//   //                           },
//   //                           child:  Text('submit',style: titleStyle,))
//   //                     ],
//   //                   ),
//   //                 ));
//   //           }));
//   // }
//   //
//   // //=================================================================DATE PICKER
//   // Future<void> _selectDate(BuildContext context) async {
//   //   final DateTime? picked = await showDatePicker(
//   //       context: context,
//   //       initialDate: selectedDate,
//   //       firstDate: firstSelectableDate,
//   //       lastDate: lastSelectableDate);
//   //
//   //   if (picked != null && picked != selectedDate) {
//   //     if(_mounted){
//   //       setState(() {
//   //         selectedDate = picked;
//   //         _visitingDateController.text =
//   //         '${selectedDate.toLocal()}'.split(' ')[0];
//   //       });
//   //     }
//   //   }
//   // }
//   //
//   // //=================================================SHOW VISIT DETAIL CONTAINER
//   // void _showVisitDetailContainer(appState, pageContext) {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     useSafeArea: true,
//   //     builder: (BuildContext context) {
//   //       return StatefulBuilder(
//   //         builder: (BuildContext context, StateSetter setState) {
//   //           return SingleChildScrollView(
//   //               child: Container(
//   //                   color: Theme.of(context).primaryColorLight,
//   //                   padding: EdgeInsets.only(
//   //                     top: MediaQuery.of(context).viewInsets.top + 16,
//   //                     bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//   //                   ),
//   //                   child: Form(
//   //                     key: _formKey,
//   //                     child: Column(
//   //                       mainAxisSize: MainAxisSize.min,
//   //                       children: [
//   //                         const SizedBox(
//   //                           height: 10,
//   //                         ),
//   //                         //===================================VISITOR NAME TEXTFIELD
//   //                         Container(
//   //                           padding: const EdgeInsets.symmetric(
//   //                             horizontal: 15,
//   //                           ),
//   //                           child: TextFormField(
//   //                               controller: _visitorNameController,
//   //                               focusNode: _visitorNameFocusNode,
//   //                               keyboardType: TextInputType.text,
//   //                               decoration: const InputDecoration(
//   //                                 labelText: 'Visitors Name',
//   //                                 border: OutlineInputBorder(),
//   //                               ),
//   //                               validator: (value) {
//   //                                 if (value!.isEmpty) {
//   //                                   return 'should not be empty';
//   //                                 }
//   //                                 return null;
//   //                               }),
//   //                         ),
//   //                         const SizedBox(
//   //                           height: 15,
//   //                         ),
//   //
//   //                         //===================================VISITOR NUMBER TEXTFIELD
//   //                         Container(
//   //                           padding: const EdgeInsets.symmetric(
//   //                             horizontal: 15,
//   //                           ),
//   //                           child: TextFormField(
//   //                               controller: _visitorNumberController,
//   //                               focusNode: _visitorNumberFocusNode,
//   //                               keyboardType: TextInputType.number,
//   //                               decoration: const InputDecoration(
//   //                                   labelText: 'Visitors Mobile Number',
//   //                                   border: OutlineInputBorder()),
//   //                               validator: (value) {
//   //                                 if (value!.isEmpty) {
//   //                                   return 'should not be empty';
//   //                                 }
//   //                                 return null;
//   //                               }),
//   //                         ),
//   //                         const SizedBox(
//   //                           height: 15,
//   //                         ),
//   //
//   //                         //===================================VISITING DATE TEXTFIELD
//   //                         Container(
//   //                           padding: const EdgeInsets.symmetric(
//   //                             horizontal: 15,
//   //                           ),
//   //                           child: TextFormField(
//   //                               controller: _visitingDateController,
//   //                               focusNode: _visitingDateFocusNode,
//   //                               keyboardType: TextInputType.number,
//   //                               decoration: const InputDecoration(
//   //                                   labelText: 'Vising Date',
//   //                                   labelStyle: TextStyle(color: Colors.black),
//   //                                   border: OutlineInputBorder()),
//   //                               onTap: (){
//   //                                 _selectDate(context);
//   //                               },
//   //                               readOnly: true,
//   //                               validator: (value) {
//   //                                 if (value!.isEmpty) {
//   //                                   return 'date should not be empty';
//   //                                 }
//   //                                 return null;
//   //                               }),
//   //                         ),
//   //                         const SizedBox(
//   //                           height: 15,
//   //                         ),
//   //
//   //                         //===================================EMPLOYEE REFERENCE NUMBER TEXTFIELD
//   //                         Container(
//   //                           padding: const EdgeInsets.symmetric(
//   //                             horizontal: 15,
//   //                           ),
//   //                           child: TextField(
//   //                             controller: _employeeRefNoController,
//   //                             focusNode: _employeeRefNoFocusNode,
//   //                             keyboardType: TextInputType.text,
//   //                             decoration: const InputDecoration(
//   //                                 labelText:
//   //                                 'Employee Reference Number ( optional )',
//   //                                 border: OutlineInputBorder()),
//   //                           ),
//   //                         ),
//   //
//   //                         //====================================SUBMIT BTN
//   //                         Padding(
//   //                           padding: const EdgeInsets.symmetric(
//   //                               horizontal: 15, vertical: 15),
//   //                           child: ElevatedButton(
//   //                               style: ElevatedButton.styleFrom(
//   //                                   backgroundColor:
//   //                                   Theme.of(context).primaryColor),
//   //                               onPressed: () {
//   //                                 if (_formKey.currentState!.validate()) {
//   //                                   var visitData = {
//   //                                     "visitor_name":
//   //                                     _visitorNameController.text,
//   //                                     "visitor_number":
//   //                                     _visitorNumberController.text,
//   //                                     "employee_un":
//   //                                     _employeeRefNoController.text ?? "",
//   //                                     "v_date": _visitingDateController.text,
//   //                                     "c_id": appState
//   //                                         .customerDetails['customer_id'],
//   //                                     "p_id": selectedProperty['property_id']
//   //                                   };
//   //                                   _mounted=true;
//   //                                   bookVisit(visitData, appState, pageContext);
//   //                                   Navigator.pop(context);
//   //                                 }
//   //                               },
//   //                               child: Text(
//   //                                 'Submit',
//   //                                 style: TextStyle(
//   //                                     color: Theme.of(context).primaryColorLight),
//   //                               )),
//   //                         )
//   //                       ],
//   //                     ),
//   //                   )));
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//   //
//   // //==================================================LOAD OFFER
//   // _loadOffer(appState)async{
//   //   if(_mounted){
//   //     setState(() {
//   //       _isOfferLoading = true;
//   //     });
//   //   }
//   //   var data = {"p_id":selectedProperty['property_id']};
//   //   var url = Uri.parse(ApiLinks.fetchOffer);
//   //   final res = await StaticMethod.fetchOffer(url,data);
//   //   if(res.isNotEmpty){
//   //     if(res['success']==true){
//   //       if(res['result'].length!=0){
//   //         offer = res['result'][0];
//   //       }else{
//   //         offer = {};
//   //       }
//   //       //print(offer);
//   //       if(_mounted){
//   //         setState(() {
//   //           _isOfferLoading=false;
//   //         });
//   //       }
//   //     }else{
//   //       // display some another widget for message
//   //       offer = {};
//   //       setState(() {
//   //         _isOfferLoading=false;
//   //       });
//   //       //print('${res['error']}');
//   //       StaticMethod.showDialogBar(res['error'], Colors.green);
//   //     }
//   //   }
//   // }
//   //
//   // //========================================================REMOVE FROM FAVORITE
//   // removeOffer(data, appState, context) async {
//   //   _mounted=true;
//   //   var url = Uri.parse(ApiLinks.deleteOffer);
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (dialogContext) => const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   );
//   //   final res =
//   //   await StaticMethod.deletOffer(url, data, appState.token);
//   //   if (res.isNotEmpty) {
//   //     Navigator.pop(context);
//   //     if (res['success'] == true) {
//   //       StaticMethod.showDialogBar(res['message'], Colors.green);
//   //       if(_mounted){
//   //         setState(() {
//   //           offer = {};
//   //         });
//   //       }
//   //       //_loadOffer(appState);
//   //     } else {
//   //       StaticMethod.showDialogBar(res['message'], Colors.red);
//   //     }
//   //   }
//   // }
//   //
//   // //=====================================================FETCH SINGLE PROPERTY
//   // _fetchSingleProperty(appState)async{
//   //   if(_mounted){
//   //     setState(() {
//   //       _isPropertyLoading = true;
//   //     });
//   //   }
//   //   var data = {"p_id":appState.p_id};
//   //   var url = Uri.parse(ApiLinks.fetchSinglePropertyById);
//   //   final res = await StaticMethod.fetchSingleProperties(data, url);
//   //   if(res.isNotEmpty){
//   //     if(res['success']==true){
//   //       if(res['result'].length!=0){
//   //         selectedProperty = res['result'][0];
//   //         appState.selectedProperty = res['result'][0];
//   //         //print(selectedProperty);
//   //         totalRating = int.parse(selectedProperty['property_rating']);
//   //         totalReview = selectedProperty['total_review'];
//   //         if(totalRating>0){
//   //           propertyRating = totalRating/totalReview;
//   //         }
//   //         _mounted=true;
//   //         _loadOffer(appState);
//   //       }else {
//   //         selectedProperty = {};
//   //       }
//   //       if(_mounted){
//   //         setState(() {
//   //           _isPropertyLoading=false;
//   //         });
//   //       }
//   //     }else{
//   //       // display some another widget for message
//   //       appState.error = res['error'];
//   //       appState.errorString=res['message'];
//   //       appState.fromWidget=appState.activeWidget;
//   //       Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
//   //         _mounted=true;
//   //         _fetchSingleProperty(appState);
//   //       });
//   //     }
//   //   }
//   // }
//
//   // @override
//   // void initState() {
//   //   final appState = Provider.of<MyProvider>(context, listen: false);
//   //   _mounted=true;
//   //   _fetchSingleProperty(appState);
//   //   _mounted=true;
//   //   fetchFavoriteProperty(appState);
//   //   super.initState();
//   // }
//   //
//   // @override
//   // void dispose() {
//   //   _mounted=false;
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<MyProvider>(context);
//     double fontSizeScaleFactor =
//         MyConst.deviceWidth(context) / MyConst.referenceWidth;
//     if(selectedProperty['property_isAvailable']=="Available"){
//       availabilityColor=Colors.green;
//     }else if(selectedProperty['property_isAvailable']=="Not Available"){
//       availabilityColor=Colors.red;
//     }else if(selectedProperty['property_isAvailable']=="Sold"){
//       availabilityColor=Colors.orange;
//     }
//     return RefreshIndicator(
//         child: PopScope(
//           canPop: true,
//           onPopInvoked: (didPop) {
//             appState.addedToFavorite = false;
//             appState.activeWidget = "PropertyListPage";
//           },
//           child: Scaffold(
//             backgroundColor: context.theme.backgroundColor,
//             appBar: _appBar('Project Property Details'),
//             body: PropertyDetailPage()
//           )
//         ),
//         onRefresh: ()async{
//           // appState.activeWidget=appState.activeWidget;
//           // _isPropertyLoading=false;
//           // _isOfferLoading=false;
//           // _loadOffer(appState);
//           // _fetchSingleProperty(appState);
//         }
//     );
//   }
//   _appBar(appBarContent){
//     return AppBar(
//       leading: IconButton(
//         onPressed: (){Get.back();},
//         icon: Icon(Icons.arrow_back_ios),
//       ),
//       iconTheme: IconThemeData(
//         color: Get.isDarkMode ?  Colors.white70 :Colors.black,
//         size: MyConst.deviceHeight(context)*0.030,
//       ),
//       toolbarHeight: MyConst.deviceHeight(context)*0.060,
//       titleSpacing: MyConst.deviceHeight(context)*0.02,
//       elevation: 0.0,
//       title:Text(
//         appBarContent,
//         style: appbartitlestyle,
//         softWrap: true,
//       ),
//       actions: [
//         Container(
//           margin: EdgeInsets.only(right: 20),
//           child: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Image.asset(
//                 'assets/images/ic_launcher.png',
//                 height: 100,
//               )
//           ),
//         ),
//       ],
//       backgroundColor: Get.isDarkMode
//           ? Colors.black45 : Colors.white,
//     );
//   }
// }
