import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/RatingDisplayWidget.dart';
import 'package:real_state/Widgets/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({Key? key}) : super(key: key);

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  bool filterApplied=false;

  int minPrice = 1;
  int maxPrice = 100000000;
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
                    margin: EdgeInsets.only(left: 15,right: 15),
                    child: Text(
                        'Enter Price Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                        Expanded(
                          child:Container(
                            margin: EdgeInsets.only(left: 15,right: 5),
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
                        ) ,),),
                     Expanded(
                       child: Container(
                           margin: EdgeInsets.only(left: 5,right: 15),
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
                     )),)
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
                              selectedCity = "";
                              selectedPropertyType = "";
                              selectedPropertyName = "";
                              StaticMethod.filterProperties(appState,
                                  propertyName: selectedPropertyName,
                                  selectedCity: selectedCity,
                                  selectedPropertyType: selectedPropertyType);
                              filterApplied=false;
                              Navigator.pop(context);
                              setTheState();
                            },
                            child: Text('Clear Filter',style: TextStyle(color: Colors.red),)),
                        ElevatedButton(
                            onPressed: () {
                              StaticMethod.filterProperties(appState,
                                  propertyName: selectedPropertyName,
                                  selectedCity: selectedCity,
                                  minPrice: minPrice,
                                  maxPrice: maxPrice,
                                  selectedPropertyType: selectedPropertyType);
                              filterApplied=true;
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
    return Column(
      children: [
        //------------------------------------search and filter btn
        Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    selectedPropertyName = value;
                    setState(() {
                      StaticMethod.filterProperties(appState,
                          propertyName: selectedPropertyName,
                          selectedCity: selectedCity,
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
            ],
          ),
        ),

        //-----------------------------------offer container
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          child: Center(
            child: Text('offer here'),
          ),
        ),

        //-------------------------------property list container
        Container(
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
                        //-----------------------------------------property imagges container
                        Container(
                          margin: EdgeInsets.all(8),
                          child:Center(
                            child: ClipRRect(

                              borderRadius: BorderRadius.circular(10),
                              child: property['pi_name'].length>0 ? Image.network(
                                  '${ApiLinks.accessPropertyImages}/${property['pi_name'][0]}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              )
                                  : Image.asset('assets/images/home.jpg',height: 100,width: 100,),
                            ),
                          ),
                        ),

                        //----------------------------------------detail container
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  '${property['p_name']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              Text(
                                '${property['p_area']} sq feet',
                                style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹',
                                    style: TextStyle(fontSize: 14,color: Theme.of(context).hintColor,fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${property['p_price']}',
                                    style: TextStyle(fontSize: 14,color: Colors.grey, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_pin,color: Theme.of(context).hintColor,size: 20,),
                                  Expanded(child: Container(child:Text(
                                    '${property['p_locality']}, ${property['p_city']}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),)
                                ],
                              ),

                              //--------------------------------------------ratings
                              Row(
                                children: [
                                  RatingDisplayWidgetTwo(rating: property['p_rating'].toDouble(),),
                                  Text(
                                    '(${property['p_rating_count']})'
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
        )))
      ],
    );
  }
}
