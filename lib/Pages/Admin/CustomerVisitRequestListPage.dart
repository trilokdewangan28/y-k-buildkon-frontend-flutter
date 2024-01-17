import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

class CustomerVisitRequestListPage extends StatefulWidget {
  const CustomerVisitRequestListPage({Key? key}) : super(key: key);

  @override
  State<CustomerVisitRequestListPage> createState() =>
      _CustomerVisitRequestListPageState();
}

class _CustomerVisitRequestListPageState
    extends State<CustomerVisitRequestListPage> {
  String requestStatus = "";
  Color statusColor = Colors.orange;
  Color houseColor = Colors.white;
  Color flatColor = Colors.white;
  Color plotColor = Colors.white;
  bool houseTapped = false;
  bool flatTapped = false;
  bool plotTapped = false;
  int selectedRequestStatus = 4;

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    StaticMethod.filterCustomerRequest(appState,
        selectedRequestStatus: selectedRequestStatus);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return Column(
      children: [
        const SizedBox(height: 10,),
        //=====================================FILTER USING REQUEST STATUS
        Container(
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  houseTapped = !houseTapped;
                  flatTapped = false;
                  plotTapped = false;
                  if (houseTapped == true) {
                    selectedRequestStatus = 0;
                    StaticMethod.filterCustomerRequest(appState,
                        selectedRequestStatus: selectedRequestStatus);
                  } else {
                    selectedRequestStatus = 4;
                    StaticMethod.filterCustomerRequest(appState,
                        selectedRequestStatus: selectedRequestStatus);
                  }
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 110,
                  decoration: BoxDecoration(
                      color: houseTapped
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                      child: Text(
                    'Pending',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  flatTapped = !flatTapped;
                  houseTapped = false;
                  plotTapped = false;
                  if (flatTapped == true) {
                    selectedRequestStatus = 1;
                    StaticMethod.filterCustomerRequest(appState,
                        selectedRequestStatus: selectedRequestStatus);
                  } else {
                    selectedRequestStatus = 4;
                    StaticMethod.filterCustomerRequest(appState,
                        selectedRequestStatus: selectedRequestStatus);
                  }
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 110,
                  decoration: BoxDecoration(
                      color: flatTapped
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                      child: Text(
                    'Accepted',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  plotTapped = !plotTapped;
                  houseTapped = false;
                  flatTapped = false;
                  if (plotTapped == true) {
                    selectedRequestStatus = 2;
                    StaticMethod.filterCustomerRequest(appState,
                        selectedRequestStatus: selectedRequestStatus);
                  } else {
                    selectedRequestStatus = 4;
                    StaticMethod.filterCustomerRequest(appState,
                        selectedRequestStatus: selectedRequestStatus);
                  }
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 110,
                  decoration: BoxDecoration(
                      color: plotTapped
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                      child: Text(
                    'Completed',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
                ),
              )
            ],
          ),
        ),
        //=====================================PROPERTY LIST CONTAINER
         Expanded(
                child: ListView.builder(
          itemCount: appState.filteredCustomerRequestList.length,
          itemBuilder: (context, index) {
            final property = appState.filteredCustomerRequestList[index];
            if (property['v_status'] == 0) {
              requestStatus = "Pending";
              statusColor = Colors.orange;
            } else if (property['v_status'] == 1) {
              requestStatus = "Accepted";
              statusColor = Colors.green;
            } else {
              requestStatus = "Completed";
              statusColor = Colors.red;
            }
            return InkWell(
              onTap: () {
                appState.selectedCustomerRequest = property;
                appState.activeWidget = "CustomerVisitRequestDetailPage";
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
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
                              borderRadius: BorderRadius.circular(10),
                              child: property['c_profilePic'].length > 0
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          '${ApiLinks.accessCustomerProfilePic}/${property['c_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                      placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'assets/images/home.jpg',
                                      height: 100,
                                      width: 100,
                                    ),
                            ),
                          ),
                        ),

                        //==============================CUSTOMER REQUEST DETAIL CONTAINER
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //=======================CUSTOMER NAME CONTAINER
                               Text(
                                  '${property['c_name'].toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  softWrap: true,
                                ),


                              //=======================AREA TEXT
                              Text(
                                '${property['p_name']}',
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
                                        color: Theme.of(context).hintColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${property['p_price']}',
                                    style: const TextStyle(
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
                                    child: Text(
                                      '${property['p_locality']}, ${property['p_city']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              //=======================RATING ROW SECTION
                              Row(
                                children: [
                                  RatingDisplayWidgetTwo(
                                    rating: property['p_rating'].toDouble(),
                                  ),
                                  Text('(${property['p_ratingCount']})')
                                ],
                              ),

                              //========================REQUEST STATUS
                               Text(
                                  requestStatus,
                                  style: TextStyle(color: statusColor),
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
      ],
    );
  }
}
