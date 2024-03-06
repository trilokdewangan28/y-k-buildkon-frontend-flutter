import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Admin/AdminProfilePage.dart';
import 'package:real_state/Pages/Admin/CustomerDetailPage.dart';
import 'package:real_state/Pages/Admin/CustomerListPage.dart';
import 'package:real_state/Pages/Admin/CustomerVisitRequestDetailPage.dart';
import 'package:real_state/Pages/Admin/CustomerVisitRequestListPage.dart';
import 'package:real_state/Pages/Admin/EmployeeDetailPage.dart';
import 'package:real_state/Pages/Admin/EmployeeListPage.dart';
import 'package:real_state/Pages/Customer/CustomerProfilePage.dart';
import 'package:real_state/Pages/Customer/FavoritePropertyDetailPage.dart';
import 'package:real_state/Pages/Customer/VisitRequestedDetailPage.dart';
import 'package:real_state/Pages/Customer/VisitRequestedListPage.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/Property/PropertyDetailPage.dart';
import 'package:real_state/Pages/Property/PropertyListPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Admin/AddNewProjectWidget.dart';
import 'package:real_state/Widgets/Admin/AddNewPropertyWidget.dart';
import 'package:real_state/Widgets/Admin/AdminLoginWidget.dart';
import 'package:real_state/Widgets/Admin/AdminProfileWidget.dart';
import 'package:real_state/Widgets/Customer/LoginWidget.dart';
import 'package:real_state/Widgets/Customer/ProfileWidget.dart';
import 'package:real_state/Widgets/Customer/SignupWidget.dart';

import 'package:real_state/Widgets/Employee/EmployeeLoginWidget.dart';
import 'package:real_state/Widgets/Employee/EmployeeProfileWidget.dart';
import 'package:real_state/Widgets/Other/AppDrawerWidget.dart';
import 'package:real_state/Widgets/Other/EmiCalculatorWidget.dart';

import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/services/ThemeService/ThemeServices.dart';

import '../Pages/Customer/FavoritePropertyListPage.dart';
import '../services/ThemeService/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool darkMode = false;

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
  Widget build(BuildContext context) {
    //final appState = Provider.of<MyProvider>(context);
    

    Widget darkModeAction = IconButton(
        onPressed: () {
          darkMode = !darkMode;
          //print(darkMode);
          setState(() {
            myAppState(context).toggleTheme();
          });
          //logout();
        },
        icon: darkMode == false
            ? const Icon(
                Icons.dark_mode,
                color: Colors.black,
              )
            : const Icon(
                Icons.light_mode,
                color: Colors.black,
              ));
    String secondBtmContent =
    myAppState(context).userType != "" && myAppState(context).token != "" ? 'Profile' : 'Login';
    IconData btmIcon = myAppState(context).userType != "" && myAppState(context).token != ""
        ? Icons.person_outline
        : Icons.login;

    //================== CONDITIONALLY PAGE NAVIGATION==========================
    Widget widgetContent = LoginWidget();
    String appBarContent = 'Y&K BUILDCON';
    switch (myAppState(context).activeWidget) {
      case "PropertyListPage":
        widgetContent = const PropertyListPage();
        appBarContent = 'Y&K BUILDCON';
        break;
      case "LoginWidget":
        if (myAppState(context).userType.isNotEmpty && myAppState(context).token.isNotEmpty) {
          if (myAppState(context).userType == "admin") {
            widgetContent = const AdminProfileWidget();
            appBarContent = "Admin Profile";
          } else if(myAppState(context).userType == "customer") {
            widgetContent = const ProfileWidget();
            appBarContent = "Customer Profile";
          }else{
            widgetContent = const EmployeeProfileWidget();
            appBarContent = "Employee Profile";
          }
          secondBtmContent = "Profile";
        } else {
          widgetContent = const LoginWidget();
          secondBtmContent = "Login";
          appBarContent = "Customer Login";
        }
        break;
      case "SignupWidget":
        widgetContent = const SignupWidget();
        appBarContent = 'Customer Registration';
        secondBtmContent = 'Registration';
        btmIcon = Icons.person_add_outlined;
      case "ProfileWidget":
        if (myAppState(context).userType == "admin") {
          widgetContent = const AdminProfilePage();
          appBarContent = "Admin Profile";
        }else if(myAppState(context).userType=='employee'){
          print('employee profile section');
          widgetContent = const EmployeeProfileWidget();
          appBarContent = "Employee Profile";
        }
        else {
          widgetContent = const CustomerProfilePage();
          appBarContent = "Customer Profile";
        }
        secondBtmContent = 'Profile';
        btmIcon = Icons.person_outline;
        break;
      case "PropertyDetailPage":
        widgetContent = const PropertyDetailPage();
        appBarContent = 'Property Details';
        break;
      case "FavoritePropertyDetailPage":
        widgetContent = const FavoritePropertyDetailPage();
        appBarContent = 'Your Favorite Property';
        break;
      case "FavoritePropertyListPage":
        widgetContent = const FavoritePropertyListPage();
        appBarContent = "Favorite List";
        break;
      case "VisitRequestedListPage":
        widgetContent = const VisitRequestedListPage();
        appBarContent = "Your Request List";
        break;
      case "VisitRequestedDetailPage":
        widgetContent = const VisitRequestedDetailPage();
        appBarContent = "Your Requested Property";
        break;
      case "EmiCalculatorWidget":
        widgetContent = const EmiCalculatorWidget();
        appBarContent = "EMI CALCULATOR";
        break;
      case "AdminLoginWidget":
        if (myAppState(context).token.isNotEmpty && myAppState(context).userType.isNotEmpty) {
          if(myAppState(context).userType=='admin'){
            widgetContent = const AdminProfileWidget();
            appBarContent = "Admin Profile";
            //appState.currentState = 1;
          }else{
            widgetContent = const AdminLoginWidget();
            appBarContent = "Admin Login";
            btmIcon = Icons.login;
            //appState.currentState = 1;
          }
        } else {
          widgetContent = const AdminLoginWidget();
          appBarContent = "Admin Login";
          //appState.currentState = 1;
        }
        break;
      case "EmployeeLoginWidget":
        if (myAppState(context).token.isNotEmpty && myAppState(context).userType.isNotEmpty) {
          if(myAppState(context).userType=='employee'){
            widgetContent = const EmployeeProfileWidget();
            appBarContent = "Employee Profile";
            //appState.currentState = 1;
          }else{
            widgetContent = const EmployeeLoginWidget();
            appBarContent = "Employee Login";
            btmIcon = Icons.login;
            //appState.currentState = 1;
          }
        } else {
          widgetContent = const EmployeeLoginWidget();
          appBarContent = "Employee Login";
          //appState.currentState = 1;
        }
        break;  
      case "CustomerVisitRequestListPage":
        widgetContent = const CustomerVisitRequestListPage();
        appBarContent = "Customer Request";
        break;
      case "CustomerVisitRequestDetailPage":
        widgetContent = const CustomerVisitRequestDetailPage();
        appBarContent = "Request Detail";
      case "AddNewPropertyWidget":
        widgetContent = const AddNewPropertyWidget();
        appBarContent = "Add New Property";
        break;
      case "AddNewProjectWidget":
        widgetContent = const AddNewProjectWidget();
        appBarContent="Add New Project";
        break;
      case "SpacificErrorPage":
        widgetContent=const SpacificErrorPage();
        break;
      case "CustomerListPage":
        widgetContent=const CustomerListPage();
        appBarContent="Customer List";
        break;
      case "CustomerDetailPage":
        widgetContent=CustomerDetailPage();
        appBarContent="Customer Details";
        break;
      case "EmployeeListPage":
        widgetContent = EmployeeListPage();
        appBarContent = "Employee List";
        break;
      case "EmployeeDetailPage":
        widgetContent=EmployeeDetailPage();
        appBarContent = "Employee Details";
        
    }
    return PopScope(
        canPop: true,
        onPopInvoked:(didPop) {
          //appState.propertyList = [];
          },
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar:_appBar(appBarContent),
        body: widgetContent,
        bottomNavigationBar:_bottomNavigation(btmIcon, secondBtmContent, myAppState(context)),
        drawer:const AppDrawerWidget(),
      )
    );
  }
  _appBar(appBarContent){
    return AppBar(
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
              //ThemeServices().switchTheme(); 
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
      backgroundColor: context.theme.backgroundColor,
      selectedFontSize: MyConst.smallTextSize*fontSizeScaleFactor(context),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      unselectedFontSize: MyConst.smallTextSize*fontSizeScaleFactor(context)*0.9,
      currentIndex: appState.currentState,
      onTap: (index) async {
        //setState(() {
        appState.currentState = index;
        switch (index) {
          case 0:
           appState.activeWidget = 'PropertyListPage';
            break;
          case 1:
            appState.token.isNotEmpty && appState.userType.isNotEmpty
                ? appState.activeWidget = "ProfileWidget"
                : appState.activeWidget = 'LoginWidget';
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
  _curvedNavigationBar(){
    
  }
}
