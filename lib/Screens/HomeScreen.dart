import 'package:flutter/material.dart';
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

import '../Pages/Customer/FavoritePropertyListPage.dart';

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
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;

    Widget darkModeAction = IconButton(
        onPressed: () {
          darkMode = !darkMode;
          //print(darkMode);
          setState(() {
            appState.toggleTheme();
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
        appState.userType != "" && appState.token != "" ? 'profile' : 'login';
    IconData btmIcon = appState.userType != "" && appState.token != ""
        ? Icons.person
        : Icons.login;

    //================== CONDITIONALLY PAGE NAVIGATION==========================
    Widget widgetContent = appState.token.length!=0 && appState.userType.length!=0 ? PropertyListPage() : LoginWidget();
    String appBarContent = 'Y&K BUILDCON';
    switch (appState.activeWidget) {
      case "PropertyListPage":
        widgetContent = const PropertyListPage();
        appBarContent = 'Y&K BUILDCON';
        break;
      case "LoginWidget":
        if (appState.userType.isNotEmpty && appState.token.isNotEmpty) {
          if (appState.userType == "admin") {
            widgetContent = const AdminProfileWidget();
            appBarContent = "Admin Profile";
          } else if(appState.userType == "customer") {
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
        btmIcon = Icons.person_add;
      case "ProfileWidget":
        if (appState.userType == "admin") {
          widgetContent = const AdminProfilePage();
          appBarContent = "Admin Profile";
        }else if(appState.userType=='employee'){
          print('employee profile section');
          widgetContent = const EmployeeProfileWidget();
          appBarContent = "Employee Profile";
        }
        else {
          widgetContent = const CustomerProfilePage();
          appBarContent = "Customer Profile";
        }
        secondBtmContent = 'Profile';
        btmIcon = Icons.person;
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
        if (appState.token.isNotEmpty && appState.userType.isNotEmpty) {
          if(appState.userType=='admin'){
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
        if (appState.token.isNotEmpty && appState.userType.isNotEmpty) {
          if(appState.userType=='employee'){
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
        resizeToAvoidBottomInset: false,
        appBar:AppBar(
          iconTheme: IconThemeData(
              color:Colors.black,
              size: MyConst.deviceHeight(context)*0.030
          ),
          toolbarHeight: MyConst.deviceHeight(context)*0.060,
          titleSpacing: MyConst.deviceHeight(context)*0.02,
          elevation: 10,
          title: Row(
            children: [
              Image.asset(
                'assets/images/ic_launcher.png',
                width: MyConst.deviceHeight(context)*0.05,
              ),
              SizedBox(width: MyConst.deviceWidth(context)*0.020,),
              Expanded(
                child: Text(
                  appBarContent,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: MyConst.mediumTextSize*fontSizeScaleFactor,
                      overflow: TextOverflow.ellipsis),
                  softWrap: true,
                ),
              ),
            ],
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              // bottomRight: Radius.circular(40),
              // topRight: Radius.circular(40),
              //topRight: Radius.circular(50)
            ),
          ),
          //actions: [darkModeAction],
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        body: widgetContent,
        bottomNavigationBar: BottomNavigationBar(
          iconSize: MyConst.deviceHeight(context)*0.02,
          selectedIconTheme: IconThemeData(
            size: MyConst.deviceHeight(context)*0.03,
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
          selectedFontSize: MyConst.smallTextSize*fontSizeScaleFactor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          unselectedFontSize: MyConst.smallTextSize*fontSizeScaleFactor*0.9,
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(btmIcon),
              label: secondBtmContent,
            ),
          ],
        ),
        drawer:const AppDrawerWidget(),
      )
        );
  }
}
