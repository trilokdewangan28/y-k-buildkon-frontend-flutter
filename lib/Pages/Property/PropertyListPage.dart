import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/ServerErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Error/EmptyPropertyPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/OfferListWidget.dart';
import 'package:real_state/Widgets/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({Key? key}) : super(key: key);

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  bool filterApplied = false;

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
  String selectedPropertyType = "";
  String selectedPropertyName = "";

  List<dynamic> filteredProperties = [];

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    StaticMethod.filterProperties(appState,
        propertyName: selectedPropertyName,
        selectedCity: selectedCity,
        minPrice: minPrice,
        maxPrice: maxPrice,
        propertyId: propertyId,
        selectedPropertyType: selectedPropertyType);

    super.initState();
  }

  setTheState() {
    setState(() {});
  }

  void _showFilterContainer(appState) {
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
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      'Enter Price Range',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15, right: 5),
                          child: TextField(
                            onChanged: (value) {
                              minPrice = int.parse(value);
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'minimum price',
                                labelStyle: TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 5, right: 15),
                            child: TextField(
                              onChanged: (value) {
                                maxPrice = int.parse(value);
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'maximum price',
                                  labelStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            )),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextField(
                      onChanged: (value) {
                        selectedPropertyName = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'filter by name',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextField(
                      onChanged: (value) {
                        selectedPropertyType = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'filter by property type',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextField(
                      onChanged: (value) {
                        selectedCity = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'filter by city',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              minPrice = 1;
                              maxPrice = 100000000;
                              propertyId=0;
                              selectedCity = "";
                              selectedPropertyType = "";
                              selectedPropertyName = "";
                              StaticMethod.filterProperties(appState,
                                  propertyName: selectedPropertyName,
                                  selectedCity: selectedCity,
                                  maxPrice: maxPrice,
                                  minPrice: minPrice,
                                  propertyId: propertyId,
                                  selectedPropertyType: selectedPropertyType);
                              filterApplied = false;
                              Navigator.pop(context);
                              setTheState();
                            },
                            child: Text(
                              'Clear Filter',
                              style: TextStyle(color: Colors.red),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              StaticMethod.filterProperties(appState,
                                  propertyName: selectedPropertyName,
                                  selectedCity: selectedCity,
                                  minPrice: minPrice,
                                  maxPrice: maxPrice,
                                  propertyId: propertyId,
                                  selectedPropertyType: selectedPropertyType);
                              filterApplied = true;
                              Navigator.pop(context);
                              setTheState();
                            },
                            child: Text('Apply Filter'))
                      ],
                    ),
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
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    var url = Uri.parse(ApiLinks.fetchOfferList);
    Widget offerContent = Container();
    return Column(
      children: [
        //=====================================FILTER USING PROPERTY TYPE
        Container(
          height: 30,
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  houseTapped = !houseTapped;
                  flatTapped=false;
                  plotTapped=false;
                  if (houseTapped == true) {
                    selectedPropertyType = "house";
                    StaticMethod.filterProperties(appState,
                        propertyName: selectedPropertyName,
                        selectedCity: selectedCity,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        propertyId: propertyId,
                        selectedPropertyType: selectedPropertyType);
                  } else {
                    selectedPropertyType = "";
                    StaticMethod.filterProperties(appState,
                        propertyName: selectedPropertyName,
                        selectedCity: selectedCity,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        propertyId: propertyId,
                        selectedPropertyType: selectedPropertyType);
                  }
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  width: 110,
                  decoration: BoxDecoration(
                      color: houseTapped
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                    'House',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  flatTapped = !flatTapped;
                  houseTapped=false;
                  plotTapped=false;
                  if (flatTapped == true) {
                    selectedPropertyType = "flat";
                    StaticMethod.filterProperties(appState,
                        propertyName: selectedPropertyName,
                        selectedCity: selectedCity,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        propertyId: propertyId,
                        selectedPropertyType: selectedPropertyType);
                  } else {
                    selectedPropertyType = "";
                    StaticMethod.filterProperties(appState,
                        propertyName: selectedPropertyName,
                        selectedCity: selectedCity,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        propertyId: propertyId,
                        selectedPropertyType: selectedPropertyType);
                  }
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  width: 110,
                  decoration: BoxDecoration(
                      color: flatTapped
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                    'Flat',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  plotTapped = !plotTapped;
                  houseTapped=false;
                  flatTapped=false;
                  if (plotTapped == true) {
                    selectedPropertyType = "plot";
                    StaticMethod.filterProperties(appState,
                        propertyName: selectedPropertyName,
                        selectedCity: selectedCity,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        propertyId: propertyId,
                        selectedPropertyType: selectedPropertyType);
                  } else {
                    selectedPropertyType = "";
                    StaticMethod.filterProperties(appState,
                        propertyName: selectedPropertyName,
                        selectedCity: selectedCity,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        propertyId: propertyId,
                        selectedPropertyType: selectedPropertyType);
                  }
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  width: 110,
                  decoration: BoxDecoration(
                      color: plotTapped
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                    'Plot',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
              )
            ],
          ),
        ),

        //=====================================SEARCH AND FILTER BTN CONT.
        Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            children: [
              //=====================================FILTER BY NAME TEXTFIELD
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    selectedPropertyName = value;
                    setState(() {
                      StaticMethod.filterProperties(appState,
                          propertyName: selectedPropertyName,
                          selectedCity: selectedCity,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          propertyId: propertyId,
                          selectedPropertyType: selectedPropertyType);
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'filter by name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),

              //=====================================FILTER BTN
              Stack(
                children: [
                  Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {
                        _showFilterContainer(appState);
                      },
                    ),
                  ),
                 filterApplied ? Positioned(
                    bottom: 10,
                      right: 12,
                      child: Icon(Icons.circle, color: Colors.red, size: 10,)
                  ) : Container()
                ],
              )
            ],
          ),
        ),

        //=====================================OFFER CONTAINER
        Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Container(
            child: FutureBuilder<Map<String, dynamic>>(
              future: StaticMethod.fetchOfferList(url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a circular progress indicator while waiting for data.
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError ) {
                  // Handle error state.
                  if (snapshot.error is SocketException) {
                    // Handle network-related errors (internet connection loss).
                    return InternetErrorPage();
                  } else {
                    // Handle other errors (server error or unexpected error).
                    return ServerErrorPage(errorString: snapshot.error.toString(),);
                  }
                }
                else if(snapshot.hasData){

                  // Display user details when data is available.
                  if(snapshot.data!['success']==true){
                    final offerResult = snapshot.data!;
                    //print('property list is ${propertyResult}');
                    if(offerResult['result'].length!=0){
                      appState.offerList = offerResult['result'];
                      offerContent = appState.offerList.length>0 ?  OfferListWidget() : Container(child: Text('empty offer'),);
                    }else{
                      offerContent = EmptyPropertyPage(text: "empty offers",);
                    }
                    return offerContent;
                  }else{
                    return SpacificErrorPage(errorString: snapshot.data!['message'],);
                  }
                }
                else{
                  return ServerErrorPage(errorString: snapshot.error.toString(),);
                }
              },
            ),
          )
        ),
        SizedBox(height: 20,),

        //=====================================PROPERTY LIST CONTAINER
        appState.filteredPropertyList.length>0
            ? Container(
            child: Expanded(
                child: ListView.builder(
          itemCount: appState.filteredPropertyList.length,
          itemBuilder: (context, index) {
            final property = appState.filteredPropertyList[index];
            return InkWell(
              onTap: () {
                appState.selectedProperty = property;
                appState.activeWidget = "PropertyDetailPage";
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  child: Card(
                    shadowColor: Colors.black,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //==============================PROPERTY IMAGE CONTAINER
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: property['pi_name'].length > 0
                                  ? Image.asset(
                                      'assets/images/home.jpg',
                                      height: 100,
                                      width: 100,
                                    )
                                  : Image.asset(
                                      'assets/images/home.jpg',
                                      height: 100,
                                      width: 100,
                                    ),
                            ),
                          ),
                        ),

                        //==============================PROPERTY DETAIL CONTAINER
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //=======================NAME CONTAINER
                              Container(
                                child: Text(
                                  '${property['p_name'].toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  softWrap: true,
                                ),
                              ),

                              //=======================AREA TEXT
                              Text(
                                '${property['p_area']} sq feet',
                                style: TextStyle(
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
                                        color: Theme.of(context).hintColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${property['p_price']}',
                                    style: TextStyle(
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
                                    color: Theme.of(context).hintColor,
                                    size: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Text(
                                      '${property['p_locality']}, ${property['p_city']}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                                  )
                                ],
                              ),

                              //=======================RATING ROW SECTION
                              Row(
                                children: [
                                  RatingDisplayWidgetTwo(
                                    rating: property['p_rating'].toDouble(),
                                  ),
                                  Text('(${property['p_rating_count']})')
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
        )))
            : Container(
          margin: EdgeInsets.symmetric(vertical:100 ),
          child: Center(
            child: Text(
              'No Such Properties',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        )
      ],
    );
  }
}

// CachedNetworkImage(
// imageUrl: '${ApiLinks.accessPropertyImages}/${property['pi_name'][0]}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
// placeholder: (context, url) =>LinearProgressIndicator(),
// errorWidget: (context, url, error) => Icon(Icons.error),
// //height: 100,
// width: 100,
// fit: BoxFit.fill,
// )
