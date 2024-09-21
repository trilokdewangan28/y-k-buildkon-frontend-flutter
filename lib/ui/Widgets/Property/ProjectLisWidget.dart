import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';
import 'package:JAY_BUILDCON/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:JAY_BUILDCON/ui/Widgets/Property/ProjectDetailWidget.dart';

class ProjectListWidget extends StatefulWidget {
  const ProjectListWidget({super.key});

  @override
  State<ProjectListWidget> createState() => _ProjectListWidgetState();
}

class _ProjectListWidgetState extends State<ProjectListWidget> {
  bool _mounted = false;
  //======================================PAGINATION AND FILTER VARIABLE===================
  int page = 1;
  final int limit = 60;
  String searchItem = "";
  //===================================project related variable
  bool _isProjectLoading = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  List<dynamic> projectList = [];

  //==========================================first load method
  //==========================================first load method
  _fetchProject(appState)async{
    if(_mounted){
      setState(() {
        _isProjectLoading = true;
      });
    }
    Map<String,dynamic> paginationOptions = {
      "page":page,
      "limit":limit
    };
    var url = Uri.parse(ApiLinks.fetchProjectWithPagination);
    final res = await StaticMethod.fetchProjectWithPagination(url,paginationOptions,searchItem:searchItem );

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        projectList = res['result'];
        if(_mounted){
          setState(() {
            _isProjectLoading = false;
          });
        }
      } else {
        //print(res['error']);
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
          _mounted=true;
          _fetchProject(appState);
        });
      }
    }
  }

  //==========================================LOAD MORE METHOD
  void _fetchMoreProject(appState) async {

    if (_hasNextPage == true &&
        _isProjectLoading == false &&
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
      var url = Uri.parse(ApiLinks.fetchProjectWithPagination);
      final res = await StaticMethod.fetchProjectWithPagination(url, paginationOptions,searchItem: searchItem);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if(res['result'].length>0){
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                projectList.addAll(res['result']);
                _isProjectLoading = false;
              });
            }
          }else{
            if(_mounted){
              setState(() {
                _hasNextPage = false;
              });
            }
            StaticMethod.showDialogBar('no more content available', Colors.green);
          }
        } else {
          appState.error = res['error'];
          appState.errorString=res['message'];
          appState.fromWidget=appState.activeWidget;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _fetchProject(appState);
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
    _fetchProject(appState);
    _mounted = true;
    _controller = ScrollController()..addListener(() => _fetchMoreProject(appState));
    //print('initstate called');
    super.initState();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    //print(projectList);
    return RefreshIndicator(
        child: PopScope(
          child: Scaffold(
            backgroundColor: context.theme.colorScheme.surface,
            appBar: _appBar('Project List'),
            body: Container(
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
                            color: Get.isDarkMode?Colors.white12:Theme.of(context).primaryColorLight,
                            //shadowColor: Colors.black,
                            elevation: 1,
                            child: TextField(
                              onChanged: (value) {
                                searchItem = value;
                                _hasNextPage=true;
                                page=1;
                                //setState(() {
                                _isProjectLoading=false;
                                _fetchProject(appState);
                                //});
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: MyConst.mediumSmallTextSize *
                                      fontSizeScaleFactor),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                labelText: 'Filter By Name, locality, state, City',
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
                  const Divider(color: Colors.black,),
                  
                  //=======================PROJECT LIST
                  _isProjectLoading
                      ? SizedBox(height: 400,child: Center(child: StaticMethod.progressIndicator()),)
                      : Container(
                    child: Flexible(
                      child: ListView.builder(
                          itemCount: projectList.length,
                          itemBuilder: (context,index){
                            final project = projectList[index];
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectDetailWidget(projectData: project)));
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                color: Get.isDarkMode? darkGreyClr: Theme.of(context).primaryColorLight,
                                child: Container(
                                  child: ListTile(
                                    title: Text(
                                        '${project['project_name'].toUpperCase()} - ${project['project_un']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    subtitle: Text(
                                        '${project['project_locality']}, ${project['project_city']}, ${project['project_state']}, ${project['project_pincode']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: MyConst.smallTextSize*fontSizeScaleFactor
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    )
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
              )
            ),
          ),
        ),
        onRefresh: ()async{
          _isProjectLoading=false;
          page=1;
          _mounted=true;
          _fetchProject(appState);
        }
    );
  }
  _appBar(appBarContent){
    return AppBar(
      leading: IconButton(
        onPressed: (){Get.back();},
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: IconThemeData(
        color: Get.isDarkMode ?  Colors.white70 :Colors.black,
        size: MyConst.deviceHeight(context)*0.030,
      ),
      toolbarHeight: MyConst.deviceHeight(context)*0.060,
      titleSpacing: MyConst.deviceHeight(context)*0.02,
      elevation: 0.0,
      title:Text(
        appBarContent,
        style: appbartitlestyle,
        softWrap: true,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/ic_launcher.png',
                height: 100,
              )
          ),
        ),
      ],
      backgroundColor: Get.isDarkMode
          ? Colors.black45 : Colors.white,
    );
  }
}
