import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Property/ImageSlider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/FetchAdminContactWidget.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

class FavoritePropertyDetailPage extends StatefulWidget {
  const FavoritePropertyDetailPage({Key? key}) : super(key: key);

  @override
  State<FavoritePropertyDetailPage> createState() =>
      _FavoritePropertyDetailPageState();
}

class _FavoritePropertyDetailPageState
    extends State<FavoritePropertyDetailPage> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  final DateTime lastSelectableDate =
      DateTime.now().add(const Duration(days: 365));
  final DateTime firstSelectableDate =
      DateTime.now().add(const Duration(days: 1));
  final _visitingDateController = TextEditingController();
  final _visitorNameController = TextEditingController();
  final _visitorNumberController = TextEditingController();

  final FocusNode _visitingDateFocusNode = FocusNode();
  final FocusNode _visitorNameFocusNode = FocusNode();
  final FocusNode _visitorNumberFocusNode = FocusNode();

  bookVisit(requestData, appState, context) async {
    var url = Uri.parse(ApiLinks.requestVisit);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.requestVisit(requestData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.green),
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.red),
        )));
      }
    }
  }

  addToFavorite(data, appState, context) async {
    var url = Uri.parse(ApiLinks.addToFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.addToFavorite(data, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.green),
        )));
        fetchFavoriteProperty(appState);
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.red),
        )));
      }
    }
  }

  removeFromFavorite(data, appState, context) async {
    var url = Uri.parse(ApiLinks.removeFromFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.removeFromFavorite(data, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.green),
        )));
        appState.activeWidget = "FavoritePropertyListWidget";
        //fetchFavoriteProperty(appState);
        // setState(() {
        // });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.red),
        )));
      }
    }
  }

  fetchFavoriteProperty(appState) async {
    var data = {
      "c_id": appState.customerDetails['customer_id'],
      "p_id": appState.selectedProperty['property_id']
    };
    var url = Uri.parse(ApiLinks.fetchFavoriteProperty);
    final res = await StaticMethod.fetchFavoriteProperty(data, url);
    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print(res);
        if (res['result'].length > 0) {
          appState.addedToFavorite = true;
          setState(() {});
        } else {
          appState.addedToFavorite = false;
          setState(() {});
        }
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
      } else {
        appState.addedToFavorite = false;
        setState(() {});
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //===================================DATE PICKER
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstSelectableDate,
        lastDate: lastSelectableDate);

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _visitingDateController.text =
            '${selectedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  //===================================SUBMIT PROPERTY RATING
  submitPropertyRating(data, appState, btmSheetContext) async {
    var url = Uri.parse(ApiLinks.submitPropertyRating);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final response = await StaticMethod.submitPropertyRating(data, url);
    if (response.isNotEmpty) {
      Navigator.pop(context);
      if (response['success'] == true) {
        Navigator.pop(btmSheetContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${response['message']}',
          style: const TextStyle(color: Colors.green),
        )));
      } else {
        Navigator.pop(btmSheetContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${response['message']}',
          style: const TextStyle(color: Colors.red),
        )));
      }
    }
  }

  //===================================SHOW VISIT DETAIL CONTAINER
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
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top + 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  //===================================VISITOR NAME TEXTFIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: TextFormField(
                        controller: _visitingDateController,
                        focusNode: _visitingDateFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Vising Date',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                // color: Theme.of(context).hintColor
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            )),
                        onTap: () => _selectDate(context),
                        readOnly: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter valid locality';
                          }
                          return null;
                        }),
                  ),

                  //====================================SUBMIT BTN
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).hintColor),
                        onPressed: () {
                          var visitData = {
                            "visitor_name": _visitorNameController.text,
                            "visitor_number": _visitorNumberController.text,
                            "v_date": _visitingDateController.text,
                            "c_id": appState.customerDetails['customer_id'],
                            "p_id": appState.selectedProperty['property_id']
                          };
                          bookVisit(visitData, appState, pageContext);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Submit',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
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
                            "p_id": appState.selectedProperty['property_id'],
                            "feedback": feedbackController.text,
                            "rating": rateValue
                          };
                          submitPropertyRating(data, appState, context);
                        },
                        child: const Text('submit'))
                  ],
                ),
              ));
            }));
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
    //print(appState.selectedProperty);
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //===========================PROPERTY IMAGES
                Stack(
                  children: [
                    Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Stack(
                          children: [
                            ClipRRect(
                                child: appState.selectedProperty['pi_name'].length !=
                                    0
                                    ? Container(
                                  width: double.infinity,
                                  decoration:
                                  const BoxDecoration(color: Colors.white),
                                  child: ImageSlider(
                                    propertyData: appState.selectedProperty,
                                    asFinder: true,
                                  ),
                                )
                                    : Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const Center(
                                      child: Text('no image found')),
                                )),
                          ],
                        )),
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
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
                            _showBottomSheetForSubmitRating(context, appState);
                          }
                              : null,
                          child: RatingDisplayWidgetTwo(
                              rating:
                              appState.selectedProperty['property_rating'].toDouble())),
                      //================================RATING USER COUNT
                      Text('(${appState.selectedProperty['property_ratingCount']})')
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
                        Icons.location_on_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      Expanded(
                        child: Text(
                          '${appState.selectedProperty['property_address']}, ${appState.selectedProperty['property_locality']} , ${appState.selectedProperty['property_city']}',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
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
                      //=============================PRICE
                      Text(
                        '${appState.selectedProperty['property_price']} ₹',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).hintColor),
                      ),
                      const Spacer(),
                      //=============================FAVRITE BTN
                      IconButton(
                          onPressed: appState.userType == 'customer'
                              ? () {
                            if (appState.customerDetails.isNotEmpty) {
                              //print(appState.customerDetails);
                              var data = {
                                "c_id": appState.customerDetails['customer_id'],
                                "p_id": appState.selectedProperty['property_id']
                              };

                              appState.addedToFavorite == false
                                  ? addToFavorite(data, appState, context)
                                  : removeFromFavorite(data, appState, context);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content: Text(
                                    'you have to login. please login',
                                    style: TextStyle(color: Colors.red),
                                  )));
                            }
                          }
                              : null,
                          icon: appState.addedToFavorite == false
                              ? const Icon(Icons.favorite_outline)
                              : const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ), //-----------price
                const SizedBox(
                  height: 10,
                ),

                //=================================ROW 4
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        //------------------------------type and area
                        Row(
                          children: [
                            //=========================type container
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Type',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.home_work_outlined,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  Text(
                                    '${appState.selectedProperty['property_type']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
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
                                  const Text(
                                    'Area',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.square_foot,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  Text(
                                    '${appState.selectedProperty['property_area']} ${appState.selectedProperty['property_areaUnit']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.bedroom_parent_sharp,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  Text(
                                    '${appState.selectedProperty['property_bhk']}',
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.chair,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  Text(
                                    '${appState.selectedProperty['property_isFurnished']}',
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.park_outlined,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  Text(
                                    '${appState.selectedProperty['property_isGarden']}',
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.local_parking,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  Text(
                                    '${appState.selectedProperty['property_isParking']}',
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).hintColor,
                              foregroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            _showVisitDetailContainer(appState, context);
                          },
                          child: Text(
                            'Request Visit',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).hintColor,
                                foregroundColor:
                                Theme.of(context).primaryColor),
                            onPressed: () {
                              //Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const FetchAdminContactWidget()));
                              appState.currentState = 0;
                            },
                            child: Text(
                              'Contact Now',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))),
                  ],
                )
                    : Container(),
                appState.userType == 'customer'
                    ? Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).hintColor),
                      onPressed: () {},
                      child: Text(
                        'Book Now',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                )
                    : Container()
              ],
            ),
          )
      ),
    );
  }
}
