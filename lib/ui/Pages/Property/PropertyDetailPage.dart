import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/controller/PropertyListController.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/ui/Pages/ImagePickerPage.dart';
import 'package:real_state/ui/Pages/Offer/AddOfferPage.dart';
import 'package:real_state/ui/Pages/Property/ImageSlider.dart';
import 'package:real_state/ui/Pages/StaticContentPage/AdminContactPage.dart';
import 'package:real_state/ui/Widgets/Other/RatingDisplayWidgetTwo.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({Key? key}) : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {

  bool _mounted = false;
  final _formKey = GlobalKey<FormState>();
  
  //===========================================DATE VARIABLE
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

  bool _isOfferLoading = false;
  bool _isPropertyLoading=false;
  Map<String,dynamic> offer = {};

  List<String> available = ['Sold','Not Available','Available'];
  String selectedAvailability='Sold';
  Color availabilityColor = Colors.orange;
  
  //===========================================RATING VARIABLE
  Map<String,dynamic> selectedProperty = {};
  double propertyRating = 0.0;
  int totalRating = 0;
  int totalReview = 0;
  String selectedOption = '';

  //==================================================================BOOK VISIT
  bookVisit(requestData, appState, context) async {
    var url = Uri.parse(ApiLinks.requestVisit);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res =
        await StaticMethod.requestVisit(appState.token, requestData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  //==================================================================CHANGE PROPERTY AVAILABILITY
  changePropertyAvailability(data, appState, context) async {
    _mounted=true;
    var url = Uri.parse(ApiLinks.changePropertyAvailability);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res =
    await StaticMethod.changePropertyAvailability(appState.token, data, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget=appState.activeWidget;
        _isPropertyLoading=false;
        _isOfferLoading=false;
        _loadOffer(appState);
        _fetchSingleProperty(appState);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  //=============================================================ADD TO FAVORITE
  addToFavorite(data, appState, context) async {
    var url = Uri.parse(ApiLinks.addToFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.addToFavorite(data['token'], data, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        fetchFavoriteProperty(appState);
        if(_mounted){
          setState(() {});
        }
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  //========================================================REMOVE FROM FAVORITE
  removeFromFavorite(data, appState, context) async {
    var url = Uri.parse(ApiLinks.removeFromFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res =
        await StaticMethod.removeFromFavorite(appState.token, data, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        fetchFavoriteProperty(appState);
        if(_mounted){
          setState(() {});
        }
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  //=====================================================FETCH FAVORITE PROPERTY
  fetchFavoriteProperty(appState) async {
    _mounted=true;
    var data = {
      "c_id": appState.customerDetails['customer_id'],
      "p_id": appState.p_id
    };
    var url = Uri.parse(ApiLinks.fetchFavoriteProperty);
    final res =
        await StaticMethod.fetchFavoriteProperty(appState.token, data, url);
    if (res.isNotEmpty) {
      if (res['success'] == true) {
        print(res);
        if (res['result'].length > 0) {
          appState.addedToFavorite = true;
          if(_mounted){
            setState(() {});
          }
        } else {
          appState.addedToFavorite = false;
          if(_mounted){
            setState(() {});
          }
        }
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
      } else {
        appState.addedToFavorite = false;
        if(_mounted){
          setState(() {});
        }
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //======================================================SUBMIT PROPERTY RATING
  submitPropertyRating(data, appState, btmSheetContext) async {
    var url = Uri.parse(ApiLinks.submitPropertyRating);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final response =
        await StaticMethod.submitPropertyRating(appState.token, data, url);
    Navigator.pop(context);
    if (response.isNotEmpty) {
      if (response['success'] == true) {
        Navigator.pop(btmSheetContext);
        StaticMethod.showDialogBar(response['message'], Colors.green);
        _isPropertyLoading=false;
        _fetchSingleProperty(appState);
      } else {
        Navigator.pop(btmSheetContext);
        StaticMethod.showDialogBar(response['message'], Colors.red);
      }
    }
  }

  //==============================================SUBMIT FEEDBACK & RATING BTMST
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    const Text(
                      'select your rating',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
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
                        onPressed: () {
                          var data = {
                            "c_id": appState.customerDetails['customer_id'],
                            "p_id": selectedProperty['property_id'],
                            "feedback": feedbackController.text,
                            "rating": rateValue
                          };
                          _mounted=true;
                          submitPropertyRating(data, appState, context);
                        },
                        child: const Text('submit'))
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
      if(_mounted){
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
                    color: Theme.of(context).backgroundColor,
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                    backgroundColor:bluishClr),
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
                                      "p_id": selectedProperty['property_id']
                                    };
                                    _mounted=true;
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

  //==================================================LOAD OFFER
  _loadOffer(appState)async{
    if(_mounted){
      setState(() {
        _isOfferLoading = true;
      });
    }
    var data = {"p_id":selectedProperty['property_id']};
    var url = Uri.parse(ApiLinks.fetchOffer);
    final res = await StaticMethod.fetchOffer(url,data);
    if(res.isNotEmpty){
      if(res['success']==true){
        if(res['result'].length!=0){
          offer = res['result'][0];
        }else{
          offer = {};
        }
         //print(offer);
        if(_mounted){
          setState(() {
            _isOfferLoading=false;
          });
        }
      }else{
        // display some another widget for message
        offer = {};
        setState(() {
          _isOfferLoading=false;
        });
        ///print('${res['error']}');
        StaticMethod.showDialogBar(res['message'], Colors.green);
      }
    }
  }

  //========================================================REMOVE FROM FAVORITE
  removeOffer(data, appState, context) async {
    _mounted=true;
    var url = Uri.parse(ApiLinks.deleteOffer);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res =
    await StaticMethod.deletOffer(url, data, appState.token);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        if(_mounted){
          setState(() {
            offer = {};
          });
        }
        //_loadOffer(appState);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  //=====================================================FETCH SINGLE PROPERTY
  _fetchSingleProperty(appState)async{
    if(_mounted){
      setState(() {
        _isPropertyLoading = true;
      });
    }
    var data = {"p_id":appState.p_id};
    var url = Uri.parse(ApiLinks.fetchSinglePropertyById);
    final res = await StaticMethod.fetchSingleProperties(data, url);
    if(res.isNotEmpty){
      if(res['success']==true){
        if(res['result'].length!=0){
          selectedProperty = res['result'][0];
          appState.selectedProperty = res['result'][0];
          //print(selectedProperty);
          totalRating = int.parse(selectedProperty['property_rating']);
          totalReview = selectedProperty['total_review'];
          if(totalRating>0){
            propertyRating = totalRating/totalReview;
          }
          _mounted=true;
          _loadOffer(appState);
        }else {
          selectedProperty = {};
        }
        if(_mounted){
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
          _mounted=true;
          _fetchSingleProperty(appState);
        });
      }
    }
    _mounted=true;
    await fetchFavoriteProperty(appState);
  }
  
  _deleteProperty(data,appState,context)async{
    _mounted = true;
    var url = Uri.parse(ApiLinks.deleteProperty);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: SpinKitThreeBounce(color: primaryColor,size: 20,),
      ),
    );
    final res =
    await StaticMethod.deleteProperty(url, data, appState.token);
    print(res);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        if(_mounted){
          setState(() {
            offer = {};
          });
        }
        //_loadOffer(appState);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    _mounted=true;
    _fetchSingleProperty(appState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PropertyListController controller = Get.find();
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    if(selectedProperty['property_isAvailable']=="Available"){
      availabilityColor=Colors.green;
    }else if(selectedProperty['property_isAvailable']=="Not Available"){
      availabilityColor=Colors.red;
    }else if(selectedProperty['property_isAvailable']=="Sold"){
      availabilityColor=Colors.orange;
    }
    return RefreshIndicator(
      color: bluishClr,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            //selectedProperty={};
            appState.addedToFavorite = false;
            if(controller.appBarContent.value=='Favorite Property Detail'){
              appState.activeWidget='FavoritePropertyListPage';  
            }else if(controller.appBarContent.value=='Property Details'){
              appState.activeWidget = "PropertyListPage"; 
            }else if(controller.appBarContent.value=='Your Requested Property'){
              appState.activeWidget = 'VisitRequestedPropertyList';
            }else{
              appState.activeWidget = "PropertyListPage";
            }
          },
          child: Container(
              color: Get.isDarkMode ? darkGreyClr : context.theme.backgroundColor,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: _isPropertyLoading==false
                      ? _detailContainer(appState, fontSizeScaleFactor)
                      : _progresContainer()
              )
          ),
        ),
        onRefresh: ()async{
          appState.activeWidget=appState.activeWidget;
          _isPropertyLoading=false;
          _isOfferLoading=false;
          _loadOffer(appState);
          _fetchSingleProperty(appState);
        }
    );
  }
  _detailContainer(appState,fontSizeScaleFactor){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        _propertyAvailability(appState,context),
        _propertyImageAndEditBtn(appState, fontSizeScaleFactor),
        _nameAndRating(appState, fontSizeScaleFactor),
        _addressRow(appState,fontSizeScaleFactor),
        _priceAndFavBtn(appState, fontSizeScaleFactor),
        _spacificationContainer(appState, fontSizeScaleFactor),

        //======================================PROPERTY DESCRIPTION AND HEADING
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
            '${selectedProperty['property_desc']}',
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.grey),
            softWrap: true,
          ),
        ),

        //========================================LOCATION MAP HEADING AND IMAGE
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: const Text(
            'Location',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _locationImage(appState, fontSizeScaleFactor),

        //===========================================BUTTONS
        // appState.userType == 'customer'
        //     ? _visitContactBtn(appState, fontSizeScaleFactor)
        //     : Container(),
        //
        // appState.userType == 'customer'
        //     ? _bookBtn()
        //     : Container(),

        //=======================================OFFER RELATED ROW
        _isOfferLoading==true
            ? StaticMethod.progressIndicator()
            : offer.isNotEmpty
            ? _offerContainer(appState, fontSizeScaleFactor)
            : Container(),
        const SizedBox(height: 20,),

        //======================================OFFER ADD AND REMOVAL BUTTON
        appState.userType == 'admin'
            ? _offerAddRemoveBtn(appState, fontSizeScaleFactor)
            : Container(),
        const SizedBox(height: 20,),

        //==============================CHANGE PROPERTY STATUS BUTTON
        _changePropertyStatusBtn(appState, fontSizeScaleFactor)
      ],
    );
  }
  _propertyAvailability(appState,pageContext){
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 20),
      child:Row(
        children: [
          Text(
            '${selectedProperty['property_isAvailable']}',
            style: TextStyle(
                color: availabilityColor,
                fontWeight: FontWeight.bold
            ),
          ),
          Spacer(),
          PopupMenuButton<String>(
            color: Get.isDarkMode?Colors.white12:Colors.white,
            onSelected: (String result) {
                selectedOption = result;
              if(selectedOption=='RequestVisit'){
                _showVisitDetailContainer(appState, pageContext);
              }else if(selectedOption=='ContactNow'){
                Get.to(()=>AdminContactPage());
              }else if(selectedOption=='DeleteProperty'){
                var data = {
                  "property_id":selectedProperty['property_id']
                };
                _deleteProperty(data, appState, context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'RequestVisit',
                child: Text('Request Visit'),
              ),
              PopupMenuItem<String>(
                value: 'ContactNow',
                child: Text('Contact Now'),
              ),
              PopupMenuItem<String>(
                value: 'BookNow',
                child: Text('Book Now'),
              ),
             appState.userType=='admin' ? PopupMenuItem<String>(
                value: 'DeleteProperty',
                child: Text('Delete Property'),
              ) : PopupMenuItem(child: Container())
            ],
          ),
        ],
      )
    );
  }
  _propertyImageAndEditBtn(appState,fontSizeScaleFactor){
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 15),
            child: Stack(
              children: [
                ClipRRect(
                    child:
                    selectedProperty['pi_name']?.length != 0
                        ? Container(
                      width: double.infinity,
                      decoration:  BoxDecoration(
                          color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: ImageSlider(
                        propertyData:
                        selectedProperty,
                        asFinder: true,
                      ),
                    )
                        : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode?Colors.white30 : Theme.of(context).primaryColorLight,
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
                              selectedProperty,
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
    );
  }
  _nameAndRating(appState,fontSizeScaleFactor){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          //================================NAME
          Expanded(
            child: Text(
              '${selectedProperty['property_name'].toUpperCase()}',
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
                  rating: propertyRating
              )),
          //================================RATING USER COUNT
          Text(
            '(${totalReview})',
            style: TextStyle(
                fontSize: MyConst.smallTextSize * fontSizeScaleFactor),
          )
        ],
      ),
    );
  }
  _addressRow(appState,fontSizeScaleFactor){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Row(
        children: [
          //============================LOCATION
          Icon(
            Icons.location_pin,
            color: Get.isDarkMode?Colors.white70:Theme.of(context).primaryColor,
            size: MyConst.mediumTextSize * fontSizeScaleFactor,
          ),
          Expanded(
            child: Text(
              '${selectedProperty['property_address']}, ${selectedProperty['property_locality']} , ${selectedProperty['property_city']}',
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
    );
  }
  _priceAndFavBtn(appState,fontSizeScaleFactor){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          //============================PRICE ICON
          Icon(
            Icons.currency_rupee,
            color: Get.isDarkMode?Colors.white70:Theme.of(context).primaryColor,
            size: MyConst.mediumTextSize * fontSizeScaleFactor,
          ),
          //=============================PRICE
          Text(
            '${selectedProperty['property_price']}',
            style: TextStyle(
              fontSize: MyConst.smallTextSize * fontSizeScaleFactor,
              fontWeight: FontWeight.w700,
              color: Get.isDarkMode?Colors.white70:Theme.of(context).primaryColor,
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
                    "p_id": selectedProperty['property_id'],
                    "token":appState.token
                  };

                  _mounted = true;
                  appState.addedToFavorite == false
                      ? addToFavorite(data, appState, context)
                      : removeFromFavorite(
                      data, appState, context);
                } else {
                  StaticMethod.showDialogBar('You have to login please login now', Colors.red);
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
    );
  }
  _spacificationContainer(appState,fontSizeScaleFactor){
    return Container(
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
                        color: Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                        size: MyConst.mediumLargeTextSize *
                            fontSizeScaleFactor,
                      ),
                      Text(
                        '${selectedProperty['property_type']}',
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
                        color: Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                        size: MyConst.mediumLargeTextSize *
                            fontSizeScaleFactor,
                      ),
                      Text(
                        '${selectedProperty['property_area']} ${selectedProperty['property_areaUnit']}',
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
            selectedProperty['property_type'] == 'House' ||
                selectedProperty['property_type'] == 'Flat'
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
                        color: Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '${selectedProperty['property_bhk']}',
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
                        color: Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '${selectedProperty['property_isFurnished']}',
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
            selectedProperty['property_type'] == 'House'
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
                        color: Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '${selectedProperty['property_isGarden']}',
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
                        color: Get.isDarkMode? Colors.white70: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '${selectedProperty['property_isParking']}',
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
        ));
  }
  _locationImage(appState,fontSizeScaleFactor){
    return Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: InkWell(
          highlightColor: Theme.of(context).primaryColorDark,
          onTap: () {
            //print('map url is ${selectedProperty['p_locationUrl']}');
            StaticMethod.openMap(
                selectedProperty['property_locationUrl']);
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
        ));
  }
  _visitContactBtn(appState,fontSizeScaleFactor){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
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
            width: MediaQuery.of(context).size.width * 0.4,
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
    );
  }
  _bookBtn(){
    return Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: bluishClr,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          onPressed: () {

          },
          child: Text(
            'Book Now',
            style:
            TextStyle(color: Theme.of(context).primaryColorLight),
          )),
    );
  }
  _offerContainer(appState,fontSizeScaleFactor){
    return offer.isNotEmpty 
        ?  Container(
        width: MyConst.deviceWidth(context),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            border: Border.all(width: 1,color: Get.isDarkMode?Colors.grey:Colors.black),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'OFFERS',
                style: TextStyle(
                    fontSize: MyConst.mediumLargeTextSize*fontSizeScaleFactor,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            Text(
                '${offer['about1']}'
            ),
            Text(
                '${offer['about2']}'
            ),
            Text(
                '${offer['about3']}'
            )
          ],
        )
    ) 
        : Container();
  }
  _offerAddRemoveBtn(appState,fontSizeScaleFactor){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: bluishClr,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddOfferPage(
                        p_id: selectedProperty['property_id'],
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
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: offer.isNotEmpty ? () {
              var data={
                "offerImage":offer['image_url'],
                "p_id":offer['property_id']
              };
              removeOffer(data, appState, context);
            } : null,
            child: Text(
              'Remove Offers',
              style:
              TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.w600
              ),
            )
        )

      ],
    );
  }
  _changePropertyStatusBtn(appState,fontSizeScaleFactor){
    return appState.userType=='admin' ? Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Get.isDarkMode?Colors.grey:Colors.black),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Marked As:'),
          const SizedBox(width: 4,),
          //==========================================DROPDOWN CARD
          Card(
              color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
              elevation: 1,
              child: Container(
                  height: MyConst.deviceWidth(context)*0.1,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Center(
                    child: DropdownButton<String>(
                      value: selectedAvailability,
                      alignment: Alignment.center,
                      elevation: 16,
                      underline: Container(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          selectedAvailability = value!;
                          //print('selected property type is ${selectedPropertyType}');
                        });
                      },
                      ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                      items: available
                          .map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('${value}',
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
              )
          ),
          const SizedBox(width: 4,),
          //==========================================SUBMIT BUTTON
          Container(
            child: TextButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: bluishClr
                ),
                onPressed: selectedProperty['property_isAvailable']==selectedAvailability
                    ? null
                    :  (){
                  var data = {
                    "newStatus":selectedAvailability,
                    "p_id":selectedProperty['property_id']
                  };
                  changePropertyAvailability(data, appState, context);
                },
                child:Text(
                  'Submit',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.w600
                  ),
                )
            ),
          )
        ],
      )
        
    ) : Container();
  }
  _progresContainer(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height*0.4,),
        StaticMethod.progressIndicator()
      ],
    );
  }
}
