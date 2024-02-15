import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  Color statusColor = Colors.orange;
  //======================================PAGINATION VARIABLE===================
  int page = 1;
  final int limit = 6;
  String searchItem='';
  bool _mounted = false;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  //==========================================FIRST LOAD EMPLOYEE LIST
  _firstLoadEmployeeList(appState)async{
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    Map<String,dynamic> paginationOptions = {
      "page":page,
      "limit":limit
    };
    var url = Uri.parse(ApiLinks.fetchEmployeeList);
    final res = await StaticMethod.fetchEmployeeListWithPagination(appState, url, paginationOptions, appState.token,searchItem: searchItem);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        appState.employeeList = res['result'];
        if(_mounted){
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
          _mounted=true;
          _firstLoadEmployeeList(appState);
        });
      }
    }
  }

  //==========================================load modre method
  void _loadMoreEmployeeList(appState) async {

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300 && _mounted
    ) {
      if(_mounted){
        setState(() {
          _isLoadMoreRunning = true; // Display a progress indicator at the bottom
        });
      }

      page += 1; // Increase _page by 1
      Map<String,dynamic> paginationOptions = {
        "page":page,
        "limit":limit
      };
      var url = Uri.parse(ApiLinks.fetchEmployeeList);
      final res = await StaticMethod.fetchEmployeeListWithPagination(appState, url, paginationOptions, appState.token,searchItem: searchItem);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if(res['result'].length>0){
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                appState.employeeList.addAll(res['result']);
                _isFirstLoadRunning = false;
              });
            }
          }else{
            if(_mounted){
              setState(() {
                _hasNextPage = false;
              });
            }
            Fluttertoast.showToast(
              msg: 'No More Content Available',
              toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
              gravity: ToastGravity.TOP, // Toast position
              backgroundColor: Colors.black, // Background color of the toast
              textColor: Colors.green, // Text color of the toast message
              fontSize: 16.0, // Font size of the toast message
            );
          }
        } else {
          appState.error = res['error'];
          appState.errorString=res['message'];
          appState.fromWidget=appState.activeWidget;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _firstLoadEmployeeList(appState);
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


  late ScrollController _controller;
  @override
  void initState() {
    ///print('initstate methond called');
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _firstLoadEmployeeList(appState);
    _mounted = true;
    _controller = ScrollController()..addListener(() => _loadMoreEmployeeList(appState));
    print('initstate called');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;

    return RefreshIndicator(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            appState.employeeList = [];
            appState.activeWidget="ProfileWidget";
          },
          child: Column(
            children: [
              //=============================================FILTER CONTAINER
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MyConst.deviceHeight(context) * 0.015),
                child: Row(
                  children: [
                    //=====================================FILTER BY NAME TEXTFIELD
                    Flexible(
                      child: Card(
                        color: Theme.of(context).primaryColorLight,
                        //shadowColor: Colors.black,
                        elevation: 1,
                        child: TextField(
                          onChanged: (value) {
                            searchItem = value;
                            _hasNextPage=true;
                            page=1;
                            //setState(() {
                            _isFirstLoadRunning=false;
                            _firstLoadEmployeeList(appState);
                            //});
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: MyConst.mediumSmallTextSize *
                                  fontSizeScaleFactor),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 5),
                            labelText: 'Filter By Name, Email, Mobile, City',
                            labelStyle: TextStyle(fontSize: 15),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                          ),
                          cursorOpacityAnimates: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: MyConst.deviceHeight(context) * 0.02,
              ),

              //===========================================EMPLOYEE LIST CONTAINER
              _isFirstLoadRunning==false
                  ? appState.employeeList.isNotEmpty
                  ? Container(child: Flexible(
                  child: ListView.builder(
                    itemCount: appState.employeeList.length,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      final employee = appState.employeeList[index];
                      if(employee['status']=="Newly Applied"){
                        statusColor = Colors.orange;
                      }else if(employee['status']=='Rejected'){
                        statusColor=Colors.red;
                      }else if(employee['status']=='Joined'){
                        statusColor = Colors.green;
                      }else if(employee['status']=='Leaved'){
                        statusColor = Colors.red;
                      }
                      return InkWell(
                        onTap: () {
                          appState.employeeDetails = employee;
                          appState.activeWidget = "EmployeeDetailPage";
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.height * 0.010,
                            ),
                            child: Card(
                              shadowColor: Colors.black,
                              color: Theme.of(context).primaryColorLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0.5,
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
                                          child: employee['profilePic'].length >
                                              0
                                              ? CachedNetworkImage(
                                            imageUrl:
                                            '${ApiLinks.accessEmployeeProfilePic}/${employee['profilePic']}',
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
                                              child: Container(
                                                height:
                                                MyConst.deviceHeight(
                                                    context) *
                                                    0.12,
                                                width: MyConst.deviceWidth(
                                                    context) *
                                                    0.25,
                                                child: const Icon(Icons.person,size: 70,),
                                              )
                                          )),
                                    ),
                                  ),

                                  //==============================PROPERTY DETAIL CONTAINER
                                  Flexible(
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
                                              '${employee['name'].toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: MyConst.smallTextSize *
                                                    fontSizeScaleFactor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              softWrap: true,
                                            ),

                                            //=======================MOBILE ROW SECTION
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.email_outlined,
                                                  color:
                                                  Theme.of(context).primaryColor,
                                                  size: MyConst
                                                      .mediumSmallTextSize *
                                                      fontSizeScaleFactor,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${employee['email']}',
                                                    style: TextStyle(
                                                        fontSize: MyConst
                                                            .smallTextSize *
                                                            fontSizeScaleFactor,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                )
                                              ],
                                            ),

                                            //=======================MOBILE ROW SECTION
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  color:
                                                  Theme.of(context).primaryColor,
                                                  size: MyConst
                                                      .mediumSmallTextSize *
                                                      fontSizeScaleFactor,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${employee['mobile']}',
                                                    style: TextStyle(
                                                        fontSize: MyConst
                                                            .smallTextSize *
                                                            fontSizeScaleFactor,
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
                                                  Theme.of(context).primaryColor,
                                                  size: MyConst
                                                      .mediumSmallTextSize *
                                                      fontSizeScaleFactor,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                      '${employee['address']}, ${employee['city']}, ${employee['state']}, ${employee['pincode']}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize:
                                                          MyConst.smallTextSize *
                                                              fontSizeScaleFactor,
                                                          fontWeight: FontWeight.w500,
                                                          overflow: TextOverflow.ellipsis
                                                      ),
                                                      softWrap: true,
                                                    ))
                                              ],
                                            ),

                                            //===============================STATUS
                                            Text(
                                              '${employee['status']}',
                                              style: TextStyle(
                                                fontSize: MyConst.smallTextSize *
                                                    fontSizeScaleFactor,
                                                fontWeight: FontWeight.w500,
                                                color: statusColor
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            )),
                      );
                    },
                  )),)
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  Center(child: Text('No Such Employee'),)
                ],
              )
                  : Container(
                margin: EdgeInsets.symmetric(
                    vertical: MyConst.deviceHeight(context) * 0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

              //================================loading more
              _isLoadMoreRunning == true
                  ? const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Container(),

              _hasNextPage == false
                  ? appState.propertyList.isNotEmpty ? Container(
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the content'),
                ),
              ) : Container()
                  : Container()
            ],
          ),
        ),
        onRefresh: () async {
          // setState(() {
          _hasNextPage=true;
          page=1;
          _isFirstLoadRunning=false;
          _isLoadMoreRunning=false;
          _firstLoadEmployeeList(appState);
          appState.activeWidget = "EmployeeListPage";
          //});
        });
  }
}
