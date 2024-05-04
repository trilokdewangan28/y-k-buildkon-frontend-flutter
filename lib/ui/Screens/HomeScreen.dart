import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/controller/PropertyListController.dart';
import 'package:real_state/services/ThemeService/ThemeServices.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'package:real_state/ui/Pages/Admin/AdminProfilePage.dart';
import 'package:real_state/ui/Pages/Admin/CustomerDetailPage.dart';
import 'package:real_state/ui/Pages/Admin/CustomerListPage.dart';
import 'package:real_state/ui/Pages/Admin/CustomerVisitRequestDetailPage.dart';
import 'package:real_state/ui/Pages/Admin/CustomerVisitRequestListPage.dart';
import 'package:real_state/ui/Pages/Admin/EmployeeDetailPage.dart';
import 'package:real_state/ui/Pages/Admin/EmployeeListPage.dart';
import 'package:real_state/ui/Pages/Customer/CustomerProfilePage.dart';
import 'package:real_state/ui/Pages/Customer/FavoritePropertyDetailPage.dart';
import 'package:real_state/ui/Pages/Customer/VisitRequestedDetailPage.dart';
import 'package:real_state/ui/Pages/Customer/VisitRequestedListPage.dart';
import 'package:real_state/ui/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/ui/Pages/Property/PropertyDetailPage.dart';
import 'package:real_state/ui/Pages/Property/PropertyListPage.dart';
import 'package:real_state/ui/Widgets/Admin/AddNewProjectWidget.dart';
import 'package:real_state/ui/Widgets/Admin/AddNewPropertyWidget.dart';
import 'package:real_state/ui/Widgets/Admin/AdminLoginWidget.dart';
import 'package:real_state/ui/Widgets/Customer/LoginWidget.dart';
import 'package:real_state/ui/Widgets/Customer/ProfileWidget.dart';
import 'package:real_state/ui/Widgets/Customer/SignupWidget.dart';
import 'package:real_state/ui/Widgets/Employee/EmployeeLoginWidget.dart';
import 'package:real_state/ui/Widgets/Employee/EmployeeProfileWidget.dart';
import 'package:real_state/ui/Widgets/Other/AppDrawerWidget.dart';
import 'package:real_state/ui/Widgets/Other/EmiCalculatorWidget.dart';
import '../Pages/Customer/FavoritePropertyListPage.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool darkMode = false;
  bool _mounted = false;
  int currentindex=0;
  var _propertyListController = Get.put(PropertyListController());
  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    StaticMethod.initialFetch(appState);
    if (appState.token != "" && appState.userType != "") {
      var url=Uri.parse("");
      if (appState.userType == "admin") {
        url = Uri.parse(ApiLinks.adminProfile);
      } else if(appState.userType == "customer"){
        url = Uri.parse(ApiLinks.customerProfile);
      }else if(appState.userType == "employee"){
        url = Uri.parse(ApiLinks.employeeProfile);
      }
      StaticMethod.userProfileInitial(appState.token, url, appState);
    }
  }
  
  @override
  void dispose() {
    _mounted=false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    
 print(_propertyListController.userType.value);
    String secondBtmContent = appState.userType!='' && appState.token!=''?'Profile':'Login';
    IconData btmIcon = appState.userType!='' && appState.token!=''?Icons.person_outline :Icons.login_outlined;

    //================== CONDITIONALLY PAGE NAVIGATION==========================
    Widget widgetContent = LoginWidget();
    String appBarContent = 'Y&K BUILDCON';
    switch (currentindex) {
      case 0:
        widgetContent = const PropertyListPage();
        appBarContent = 'Y&K BUILDCON';
        break;
      case 1:
        if(appState.userType!='' && appState.token!=''){
          appBarContent = 'Profile';
          btmIcon = Icons.person_outline;
          secondBtmContent = 'Profile';
          if(appState.userType=='admin'){
            widgetContent = AdminProfilePage();
          }else if(appState.userType=='customer'){
            widgetContent = CustomerProfilePage();
          }else if(appState.userType=='employee'){
            widgetContent = EmployeeProfileWidget();
          } 
        }else{
          appBarContent = 'Login Page';
          btmIcon=Icons.login_outlined;
          secondBtmContent='Login';
          widgetContent = LoginWidget();
        }
    }
    return PopScope(
        canPop: currentindex==0 ? true : false,
        onPopInvoked:(didPop) {
          if(currentindex==1){
            currentindex = 0;
          }
        },
        child: Scaffold(
        backgroundColor:Colors.white,
        resizeToAvoidBottomInset: false,
        appBar:_appBar(appBarContent),
        body: widgetContent,
        bottomNavigationBar:_bottomNavigation(btmIcon, secondBtmContent, appState),
        drawer:const AppDrawerWidget(),
      )
    );
  }
  
  _appBar(appBarContent){
    return AppBar(
      scrolledUnderElevation: 0.0,
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
          margin: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
                'assets/images/ic_launcher.png',
              height: 100,
            )
          ),
        ),
        IconButton(
            onPressed: (){
              ThemeServices().switchTheme(); 
              StaticMethod.showDialogBar('theme changed', Colors.green);
              }, 
            icon: Icon(Get.isDarkMode? Icons.light_mode_outlined:Icons.dark_mode_outlined, color: Get.isDarkMode?Colors.grey:Colors.black,size: 24,)
        )
      ],
      backgroundColor: Get.isDarkMode 
          ? Colors.black45 : Colors.white,
    );
  }
  _bottomNavigation(btmIcon, secondBtmContent,appState){
    return BottomNavigationBar(
      iconSize: MyConst.deviceHeight(context)*0.02,
      selectedIconTheme: IconThemeData(
        size: MyConst.deviceHeight(context)*0.03,
      ),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedFontSize: MyConst.smallTextSize*fontSizeScaleFactor(context),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      unselectedFontSize: MyConst.smallTextSize*fontSizeScaleFactor(context)*0.9,
      currentIndex: currentindex,
      onTap: (index) async {
        //setState(() {
        appState.currentState = index;
        switch (index) {
          case 0:
           setState(() {
             currentindex = index;
           });
            break;
          case 1:
            setState(() {
              currentindex = index;
            });
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(btmIcon),
          label: secondBtmContent,
        ),
      ],
    );
  }
}
