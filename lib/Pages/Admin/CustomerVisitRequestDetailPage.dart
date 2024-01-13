import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Property/ImageSlider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/FetchAdminContactWidget.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

class CustomerVisitRequestDetailPage extends StatefulWidget {
  const CustomerVisitRequestDetailPage({Key? key}) : super(key: key);

  @override
  State<CustomerVisitRequestDetailPage> createState() => _CustomerVisitRequestDetailPageState();
}

class _CustomerVisitRequestDetailPageState extends State<CustomerVisitRequestDetailPage> {
  DateTime selectedDate =  DateTime.now().add(Duration(days: 1));
  final DateTime lastSelectableDate = DateTime.now().add(Duration(days: 365));
  final DateTime firstSelectableDate = DateTime.now().add(Duration(days: 1));
  final _visitingDateController = TextEditingController();
  final _visitorNameController = TextEditingController();
  final _visitorNumberController = TextEditingController();

  final FocusNode _visitingDateFocusNode = FocusNode();
  final FocusNode _visitorNameFocusNode = FocusNode();
  final FocusNode _visitorNumberFocusNode = FocusNode();

  //==================================BOOK VISIT
  bookVisit(requestData,appState,context)async{

    var url = Uri.parse(ApiLinks.requestVisit);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.requestVisit(requestData,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //==================================ADD TO FAVORITE
  addToFavorite(data,appState, context)async{
    var url = Uri.parse(ApiLinks.addToFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.addToFavorite(data,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
        fetchFavoriteProperty(appState);
        setState(() {
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //==================================REMOVE FROM FAVORITE
  removeFromFavorite(data,appState,context)async{
    var url = Uri.parse(ApiLinks.removeFromFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.removeFromFavorite(data, url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
        fetchFavoriteProperty(appState);
        setState(() {
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //==================================FETCH FAVORITE PROPERTY
  fetchFavoriteProperty(appState)async{
    var data = {
      "c_id":appState.customerDetails['c_id'],
      "p_id":appState.selectedProperty['p_id']
    };
    var url = Uri.parse(ApiLinks.fetchFavoriteProperty);
    final res = await StaticMethod.fetchFavoriteProperty(data,url);
    if(res.isNotEmpty){
      if(res['success']==true){
        print(res);
        if(res['result'].length>0){
          appState.addedToFavorite = true;
          setState(() {
          });
        }else{
          appState.addedToFavorite = false;
          setState(() {
          });
        }
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
      }else{
        appState.addedToFavorite = false;
        setState(() {

        });
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //===================================SUBMIT PROPERTY RATING
  submitPropertyRating(data,appState, btmSheetContext)async{
    var url = Uri.parse(ApiLinks.submitPropertyRating);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final response = await StaticMethod.submitPropertyRating(data,url);
    Navigator.pop(context);
    if (response.isNotEmpty) {
      if(response['success']==true){
        Navigator.pop(btmSheetContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response['message']}', style: TextStyle(color: Colors.green),)));
      }else{
        Navigator.pop(btmSheetContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //===================================SUBMIT FEEDBACK & RATING BTMST
  void _showBottomSheetForSubmitRating(BuildContext context, appState) {
    final _feedbackController = TextEditingController();
    int rateValue = 0;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context)=>StatefulBuilder(
            builder: (context,setState){
              return SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding:
                    EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'select your rating',
                          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        //--------------------------------------------RATING CONTAINER
                        Container(
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rateValue = 1;
                                      });
                                      print(rateValue);
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
                                      print(rateValue);
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
                                      print(rateValue);
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
                                      print(rateValue);
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
                                      print(rateValue);
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
                            controller: _feedbackController,
                            maxLines: null, // Allows an unlimited number of lines
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
                                "c_id":appState.customerDetails['c_id'],
                                "p_id":appState.selectedProperty['p_id'],
                                "feedback":_feedbackController.text,
                                "rating":rateValue
                              };
                              submitPropertyRating(data, appState,context);
                            },
                            child: const Text('submit'))
                      ],
                    ),
                  ));
            }
        )
    );
  }

  //===================================DATE PICKER
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstSelectableDate,
        lastDate:  lastSelectableDate
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _visitingDateController.text = '${selectedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  //===================================SHOW VISIT DETAIL CONTAINER
  void _showVisitDetailContainer(appState,pageContext) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewInsets.top + 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      //===================================VISITOR NAME TEXTFIELD
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: TextField(
                          controller: _visitorNameController,
                          focusNode: _visitorNameFocusNode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Visitors Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),

                      //===================================VISITOR NUMBER TEXTFIELD
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: TextField(
                          controller: _visitorNumberController,
                          focusNode: _visitorNumberFocusNode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Visitors Number',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),

                      //===================================VISITING DATE TEXTFIELD
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Container(
                          child:TextFormField(
                              controller: _visitingDateController,
                              focusNode: _visitingDateFocusNode,
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                                  labelText: 'Vising Date',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      // color: Theme.of(context).hintColor
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10),),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10),),
                                  )
                              ),
                              onTap: () => _selectDate(context),
                              readOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter valid locality';
                                }
                                return null;
                              }

                          ),
                        ),
                      ),

                      //====================================SUBMIT BTN
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).hintColor
                            ),
                            onPressed: (){
                              var visitData = {
                                "visitor_name":_visitorNameController.text,
                                "visitor_number":_visitorNumberController.text,
                                "v_date":_visitingDateController.text,
                                "c_id":appState.customerDetails['c_id'],
                                "p_id":appState.selectedProperty['p_id']
                              };
                              bookVisit(visitData, appState, pageContext);
                              Navigator.pop(context);

                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            )),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    fetchFavoriteProperty(appState);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //===========================PROPERTY IMAGES
              /*
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Stack(
                    children: [
                      ClipRRect(

                          child: appState.selectedCustomerRequest['pi_name'].length != 0
                              ? Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: ImageSlider(
                              propertyData: appState.selectedProperty,
                              asFinder: true,
                            ),
                          )
                              : Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25)),
                            child: const Center(child: Text('no image found')),
                          )
                      ),
                    ],
                  )
              ),

               */
              //=======================HEADING 1================================
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                child: Center(
                  child: Text(
                    'PROPERTY DETAILS',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),
                  ),
                )
              ),
              Divider(),



              //===========================PROPERTY DETAIL SECTION
              //================================== ROW 1
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['p_name'].toUpperCase()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                    //================================RATINGS
                    InkWell(
                        onTap: (){
                          _showBottomSheetForSubmitRating(context, appState);
                        },
                        child: RatingDisplayWidgetTwo(rating: appState.selectedCustomerRequest['p_rating'].toDouble())
                    ),
                    //================================RATING USER COUNT
                    Text(
                        '(${appState.selectedCustomerRequest['p_rating_count']})'
                    )

                  ],
                ),
              ),

              //==================================ROW 2
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //=============================PRICE
                    Text(
                      '${appState.selectedCustomerRequest['p_price']} ₹',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor
                      ),
                    ),

                    Spacer(),
                    //=============================MEASLE NO.
                    Text(
                      'Measle No: ${appState.selectedCustomerRequest['p_un']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor
                      ),
                    ),
                  ],
                ),
              ),     //-----------price
              // SizedBox(height: 10,),


              //==================================ROW 3
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                child: Row(
                  children: [
                    //============================LOCATION
                    Icon(Icons.location_on_outlined, color: Theme.of(context).hintColor,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['p_address']}, ${appState.selectedCustomerRequest['p_locality']} , ${appState.selectedCustomerRequest['p_city']}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),
                        softWrap: true,
                      ),
                    ))
                  ],
                ),
              ),



              //==========================================LOCATION MAP
              Container(
                margin: EdgeInsets.only(right: 15, left: 15, top: 15),
                child: Text(
                  'Location',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, ),
                  child: InkWell(
                    highlightColor: Theme.of(context).primaryColorDark,
                    onTap: () {
                      print('map url is ${appState.selectedProperty['p_locationurl']}');
                      StaticMethod.openMap(appState.selectedProperty['p_locationurl']);
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

              Divider(),

              //======================CUSTOMER DETAIL SECTION===================
              SizedBox(height: 20,),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                  child: Center(
                    child: Text(
                      'CUSTOMER DETAILS',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18
                      ),
                    ),
                  )
              ),
              Divider(),

              //==================================CUSTOMER NAME
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Text(
                      'Name:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['c_name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              //==================================CUSTOMER MOBILE
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Text(
                      'Mobile:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['c_mobile']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              //==================================CUSTOMER EMAIL
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Text(
                      'Email:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['c_email']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              //==================================CUSTOMER ADDRESS
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Text(
                      'Address:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['c_address']}, ${appState.selectedCustomerRequest['c_locality']}, ${appState.selectedCustomerRequest['c_city']}, ${appState.selectedCustomerRequest['c_pincode']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              //==================================VISITOR NAME
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Text(
                      'Visitor Name:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['visitor_name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              //==================================VISITOR NUMBER
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Text(
                      'Visitor Number:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['visitor_number']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              //==================================VISITING DATE
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    //================================NAME
                    Text(
                      'Visiting Date:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['v_date']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              //==================================STATUS CHANGE BTN
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).hintColor,
                  ),
                    onPressed: (){},
                    child: Text(
                        'Status Change Button',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),
                    )
                ),
              )

      ]
        )));
  }
}
