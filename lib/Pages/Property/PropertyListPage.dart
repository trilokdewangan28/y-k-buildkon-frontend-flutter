import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/EmptyPropertyPage.dart';
import 'package:real_state/Pages/Error/InternetErrorPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
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

  //============================================================================FILTER VARIABLE
  final List<String> propertyType = ['All', 'House', 'Flat', 'Plot'];
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

  final List<String> available = ['None', 'Yes', 'No'];
  String selectedAvailability = "Yes";

  //String onSelectAvailability = "Yes";

  List<dynamic> filteredProperties = [];

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    //appState.loadSavedPropertyType();
    print('initstate called');
    // first filter call
    StaticMethod.filterProperties(appState,
        propertyName: selectedPropertyName,
        selectedCity: selectedCity,
        minPrice: minPrice,
        maxPrice: maxPrice,
        propertyId: propertyId,
        selectedPropertyType: selectedPropertyType,
        selectedBhk: selectedBhk,
        selectedFloor: selectedFloor,
        selectedGarden: selectedGarden,
        selectedParking: selectedParking,
        selectedFurnished: selectedFurnished,
        selectedAvailability: selectedAvailability);

    super.initState();
  }

  setTheState() {
    setState(() {});
  }

  void _showFilterContainer(appState) {
    print('inside the filter container ${selectedPropertyType}');
    //_setOnselectVariable(onSelectType, onSelectBhk, onSelectFloor, onSelectGarden, onSelectParking, onSelectAvailability);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text(
                      'Apply Filters',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
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
                        //===========================SPACIFICATION CONTAINER
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              //==========================PROPERTY TYPE
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: const Text('Select Property Type: '),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Card(
                                    color: Colors.white,
                                    elevation: 1,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: selectedPropertyType,
                                            icon: const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              size: 30,
                                            ),
                                            elevation: 16,
                                            underline: Container(),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                selectedPropertyType = value!;
                                                //onSelectType = value;
                                                if (value == "All") {
                                                  houseTapped = false;
                                                  flatTapped = false;
                                                  plotTapped = false;
                                                  selectedBhk = 0;
                                                  selectedFloor = 0;
                                                  selectedGarden = "None";
                                                  selectedParking = "None";
                                                  selectedFurnished = "None";
                                                  selectedAvailability = "Yes";
                                                } else if (value == "House") {
                                                  houseTapped = true;
                                                  flatTapped = false;
                                                  plotTapped = false;
                                                } else if (value == "Flat") {
                                                  houseTapped = false;
                                                  flatTapped = true;
                                                  plotTapped = false;
                                                } else if (value == "Plot") {
                                                  houseTapped = false;
                                                  flatTapped = false;
                                                  plotTapped = true;
                                                }
                                                //print('selected property type is ${selectedPropertyType}');
                                              });
                                            },
                                            items: propertyType
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  )
                                ],
                              ),

                              //==========================PROPERTY BHK
                              selectedPropertyType == 'House' ||
                                      selectedPropertyType == "Flat"
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                              'Select Property BHK: '),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Card(
                                            elevation: 1,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  value: selectedBhk.toString(),
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down_sharp,
                                                    size: 30,
                                                  ),
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedBhk =
                                                          int.parse(value!);
                                                      //onSelectBhk = int.parse(value);
                                                      //print('selected bhk is : ${selectedBhk}');
                                                    });
                                                  },
                                                  items: bhk.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ))
                                      ],
                                    )
                                  : Container(),

                              //==========================PROPERTY FLOOR
                              selectedPropertyType == 'House'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                              'Select No. Of Floors: '),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Card(
                                            elevation: 1,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  value:
                                                      selectedFloor.toString(),
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down_sharp,
                                                    size: 30,
                                                  ),
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedFloor =
                                                          int.parse(value!);
                                                      //onSelectFloor = int.parse(value);
                                                      //print('selected floor is : ${selectedFloor}');
                                                    });
                                                  },
                                                  items: floor.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ))
                                      ],
                                    )
                                  : Container(),

                              //==========================isGarden facility
                              selectedPropertyType == 'House'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                              'Garden Availibility?: '),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Card(
                                            elevation: 1,
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: selectedGarden,
                                                    icon: const Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                      size: 30,
                                                    ),
                                                    elevation: 16,
                                                    underline: Container(),
                                                    onChanged: (String? value) {
                                                      // This is called when the user selects an item.
                                                      setState(() {
                                                        selectedGarden = value!;
                                                        //onSelectGarden = value;
                                                        //print('is Garden : ${selectedGarden}');
                                                      });
                                                    },
                                                    items: garden.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                )))
                                      ],
                                    )
                                  : Container(),

                              //==========================isParking facility
                              selectedPropertyType == 'House'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child:
                                              const Text('Parking Facility?: '),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Card(
                                            elevation: 1,
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    value: selectedParking,
                                                    icon: const Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                      size: 30,
                                                    ),
                                                    elevation: 16,
                                                    underline: Container(),
                                                    onChanged: (String? value) {
                                                      // This is called when the user selects an item.
                                                      setState(() {
                                                        selectedParking =
                                                            value!;
                                                        // onSelectParking = value;
                                                        //print('is Parking : ${selectedParking}');
                                                      });
                                                    },
                                                    items: parking.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                )))
                                      ],
                                    )
                                  : Container(),

                              //==========================isFurnished facility
                              selectedPropertyType == 'House' ||
                                      selectedPropertyType == 'Flat'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child:
                                              const Text('Furnished Or Not?: '),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Card(
                                            elevation: 1,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  value: selectedFurnished,
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down_sharp,
                                                    size: 30,
                                                  ),
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedFurnished =
                                                          value!;
                                                      //onSelectFurnished = value;
                                                      //print('is furnished : ${selectedFurnished}');
                                                    });
                                                  },
                                                  items: furnished.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ))
                                      ],
                                    )
                                  : Container(),

                              //==========================AVAILABILITY
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: const Text('Available Or Not?: '),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Card(
                                      elevation: 1,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: selectedAvailability,
                                            icon: const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              size: 30,
                                            ),
                                            elevation: 16,
                                            underline: Container(),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                selectedAvailability = value!;
                                                //onSelectAvailability = value;
                                                //print('is available : ${selectedFurnished}');
                                              });
                                            },
                                            items: available
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            child: const Text(
                              'Enter Price Range',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 5),
                                child: TextField(
                                  onChanged: (value) {
                                    minPrice = int.parse(value);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'minimum price',
                                      labelStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 15),
                                  child: TextField(
                                    onChanged: (value) {
                                      maxPrice = int.parse(value);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'maximum price',
                                        labelStyle:
                                            const TextStyle(fontSize: 14),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  )),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: TextField(
                            cursorHeight: 10,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) {
                              selectedPropertyName = value;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'filter by name',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: TextField(
                            onChanged: (value) {
                              appState.selectedPropertyType = value;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'filter by property type',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Container(
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: TextField(
                              onChanged: (value) {
                                selectedCity = value;
                              },
                              style: TextStyle(fontSize: 15),
                              cursorHeight: 15,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'filter by city',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
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
                                    selectedAvailability = "None";
                                    selectedPropertyName = "";
                                    houseTapped = false;
                                    flatTapped = false;
                                    plotTapped = false;
                                    // second filter call
                                    // _setOnselectVariable(onSelectType, onSelectBhk, onSelectFloor, onSelectGarden, onSelectParking, onSelectAvailability);
                                    StaticMethod.filterProperties(appState,
                                        propertyName: selectedPropertyName,
                                        selectedCity: selectedCity,
                                        minPrice: minPrice,
                                        maxPrice: maxPrice,
                                        propertyId: propertyId,
                                        selectedPropertyType:
                                            selectedPropertyType,
                                        selectedBhk: selectedBhk,
                                        selectedFloor: selectedFloor,
                                        selectedGarden: selectedGarden,
                                        selectedParking: selectedParking,
                                        selectedFurnished: selectedFurnished,
                                        selectedAvailability:
                                            selectedAvailability);
                                    filterApplied = false;
                                    Navigator.pop(context);
                                    setTheState();
                                  },
                                  child: const Text(
                                    'Clear Filter',
                                    style: TextStyle(color: Colors.red),
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    // third filter call
                                    //_setOnselectVariable(onSelectType, onSelectBhk, onSelectFloor, onSelectGarden, onSelectParking, onSelectAvailability);
                                    StaticMethod.filterProperties(appState,
                                        propertyName: selectedPropertyName,
                                        selectedCity: selectedCity,
                                        minPrice: minPrice,
                                        maxPrice: maxPrice,
                                        propertyId: propertyId,
                                        selectedPropertyType:
                                            selectedPropertyType,
                                        selectedBhk: selectedBhk,
                                        selectedFloor: selectedFloor,
                                        selectedGarden: selectedGarden,
                                        selectedParking: selectedParking,
                                        selectedFurnished: selectedFurnished,
                                        selectedAvailability:
                                            selectedAvailability);
                                    filterApplied = true;
                                    Navigator.pop(context);
                                    setTheState();
                                  },
                                  child: const Text('Apply Filter'))
                            ],
                          ),
                        )
                      ],
                    ),
                  )))
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    print('build method called');
    print('filtered proeprty list is : ${appState.filteredPropertyList}');
    var url = Uri.parse(ApiLinks.fetchOfferList);
    Widget offerContent = Container();
    return RefreshIndicator(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            children: [
              //===========================NAME FILTER CONTAINER
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    //=====================================FILTER BY NAME TEXTFIELD
                    Expanded(
                        child: Container(
                      height: 40,
                      child: TextField(
                        cursorHeight: 15,
                        onChanged: (value) {
                          selectedPropertyName = value;
                          setState(() {
                            // when filter by name
                            /// _setOnselectVariable(onSelectType, onSelectBhk, onSelectFloor, onSelectGarden, onSelectParking, onSelectAvailability);
                            StaticMethod.filterProperties(appState,
                                propertyName: selectedPropertyName,
                                selectedCity: selectedCity,
                                minPrice: minPrice,
                                maxPrice: maxPrice,
                                propertyId: propertyId,
                                selectedPropertyType: selectedPropertyType,
                                selectedBhk: selectedBhk,
                                selectedFloor: selectedFloor,
                                selectedGarden: selectedGarden,
                                selectedParking: selectedParking,
                                selectedFurnished: selectedFurnished,
                                selectedAvailability: selectedAvailability);
                          });
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 15),
                          textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 5),
                            labelText: 'Filter By Name',
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                          focusedBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                        ),
                        cursorOpacityAnimates: false,
                      ),
                    )),

                    //=====================================FILTER BTN
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.filter_list,
                                  size: 25,
                                ),
                                onPressed: () {
                                  //selectedPropertyType = "All";
                                  _showFilterContainer(appState);
                                },
                              ),
                            ),
                            filterApplied
                                ? const Positioned(
                                    bottom: 10,
                                    right: 12,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                      size: 10,
                                    ))
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          'Filters',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MyConst.deviceHeight(context) * 0.01,
              ),

              //=====================================OFFER CONTAINER
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: StaticMethod.fetchOfferList(url),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a circular progress indicator while waiting for data.
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      // Handle error state.
                      if (snapshot.error is SocketException) {
                        // Handle network-related errors (internet connection loss).
                        return const InternetErrorPage();
                      } else {
                        // Handle other errors (server error or unexpected error).
                        return SpacificErrorPage(
                          errorString: snapshot.error.toString(),
                          fromWidget: appState.activeWidget,
                        );
                      }
                    } else if (snapshot.hasData) {
                      // Display user details when data is available.
                      if (snapshot.data!['success'] == true) {
                        final offerResult = snapshot.data!;
                        //print('property list is ${propertyResult}');
                        if (offerResult['result'].length != 0) {
                          appState.offerList = offerResult['result'];
                          offerContent = appState.offerList.isNotEmpty
                              ? const OfferSlider()
                              : const Text('empty offer');
                        } else {
                          offerContent = const EmptyPropertyPage(
                            text: "empty offers",
                          );
                        }
                        return offerContent;
                      } else {
                        return SpacificErrorPage(
                          errorString: snapshot.data!['message'],
                          fromWidget: appState.activeWidget,
                        );
                      }
                    } else {
                      return SpacificErrorPage(
                        errorString: snapshot.error.toString(),
                        fromWidget: appState.activeWidget,
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: MyConst.deviceHeight(context) * 0.02,
              ),

              //=====================================PROPERTY LIST CONTAINER
              appState.filteredPropertyList.isNotEmpty
                  ? Expanded(
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
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
                                      margin: const EdgeInsets.all(8),
                                      child: Center(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: property['pi_name'].length >
                                                    0
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        '${ApiLinks.accessPropertyImages}/${property['pi_name'][0]}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                                    placeholder: (context,
                                                            url) =>
                                                        const LinearProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    height:
                                                        MyConst.deviceHeight(
                                                                context) *
                                                            0.1,
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
                                                              0.1,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                      ),
                                    ),

                                    //==============================PROPERTY DETAIL CONTAINER
                                    Expanded(
                                        child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //=======================NAME CONTAINER
                                          Text(
                                            '${property['property_name'].toUpperCase()}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            softWrap: true,
                                          ),

                                          //=======================AREA TEXT
                                          Text(
                                            '${property['property_area']}  ${property['property_areaUnit']}',
                                            style: const TextStyle(
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
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                '${property['property_price']}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),

                                          //=======================LOCATION ROW SECTION
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color:
                                                    Theme.of(context).hintColor,
                                                size: 20,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                '${property['property_locality']}, ${property['property_city']}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                            ],
                                          ),

                                          //=======================RATING ROW SECTION
                                          Row(
                                            children: [
                                              RatingDisplayWidgetTwo(
                                                rating: property['property_rating']
                                                    .toDouble(),
                                              ),
                                              Text(
                                                  '(${property['property_ratingCount']})')
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
                    ))
                  : Container(
                      margin: const EdgeInsets.symmetric(vertical: 100),
                      child: const Center(
                        child: Text(
                          'No Such Properties',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
            ],
          ),
        ),
        onRefresh: () async {
          // setState(() {
          appState.activeWidget = "PropertyListWidget";
          //});
        });
  }
}
