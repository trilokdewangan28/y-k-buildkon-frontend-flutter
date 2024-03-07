import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/controller/PropertyListController.dart';
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
import 'package:real_state/ui/Widgets/Admin/AdminProfileWidget.dart';
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
  Widget build(BuildContext context) {
    //final appState = Provider.of<MyProvider>(context);
    
 print(_propertyListController.userType.value);
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
        _propertyListController.appBarContent.value= 'Y&K BUILDCON';
        break;
      case "LoginWidget":
        if (myAppState(context).userType.isNotEmpty && myAppState(context).token.isNotEmpty) {
          if (myAppState(context).userType == "admin") {
            widgetContent = const AdminProfileWidget();
            appBarContent = "Admin Profile";
            _propertyListController.appBarContent.value = "Admin Profile";
          } else if(myAppState(context).userType == "customer") {
            widgetContent = const ProfileWidget();
            appBarContent = "Customer Profile";
            _propertyListController.appBarContent.value = "Customer Profile";
          }else{
            widgetContent = const EmployeeProfileWidget();
            appBarContent = "Employee Profile";
            _propertyListController.appBarContent.value = "Employee Profile";
          }
          secondBtmContent = "Profile";
        } else {
          widgetContent = const LoginWidget();
          secondBtmContent = "Login";
          appBarContent = "Customer Login";
          _propertyListController.appBarContent.value = "Customer Login";
        }
        break;
      case "SignupWidget":
        widgetContent = const SignupWidget();
        appBarContent = 'Customer Registration';
        _propertyListController.appBarContent.value = "Customer Registration";
        secondBtmContent = 'Registration';
        btmIcon = Icons.person_add_outlined;
      case "ProfileWidget":
        if (myAppState(context).userType == "admin") {
          widgetContent = const AdminProfilePage();
          appBarContent = "Admin Profile";
          _propertyListController.appBarContent.value = "Admin Profile";
        }else if(myAppState(context).userType=='employee'){
          print('employee profile section');
          widgetContent = const EmployeeProfileWidget();
          appBarContent = "Employee Profile";
          _propertyListController.appBarContent.value = "Employee Profile";
        }
        else {
          widgetContent = const CustomerProfilePage();
          appBarContent = "Customer Profile";
          _propertyListController.appBarContent.value = "Customer Profile";
        }
        secondBtmContent = 'Profile';
        btmIcon = Icons.person_outline;
        break;
      case "PropertyDetailPage":
        widgetContent = const PropertyDetailPage();
        appBarContent = 'Property Details';
        _propertyListController.appBarContent.value= "Property Details";
        break;
      case "FavoritePropertyDetailPage":
        widgetContent = const PropertyDetailPage();
        appBarContent = 'Your Favorite Property';
        _propertyListController.appBarContent.value = "Your Favorite Property";
        break;
      case "FavoritePropertyListPage":
        widgetContent = const FavoritePropertyListPage();
        appBarContent = "Favorite List";
        _propertyListController.appBarContent.value = "Favorite List";
        break;
      case "VisitRequestedListPage":
        widgetContent = const VisitRequestedListPage();
        appBarContent = "Your Request List";
        _propertyListController.appBarContent.value= "Your Request List";
        break;
      case "VisitRequestedDetailPage":
        widgetContent = const VisitRequestedDetailPage();
        appBarContent = "Your Requested Property";
        _propertyListController.appBarContent.value = "Your Requested Property";
        break;
      case "EmiCalculatorWidget":
        widgetContent = const EmiCalculatorWidget();
        appBarContent = "EMI CALCULATOR";
        _propertyListController.appBarContent.value = "EMI CALCULATOR";
        break;
      case "AdminLoginWidget":
        if (myAppState(context).token.isNotEmpty && myAppState(context).userType.isNotEmpty) {
          if(myAppState(context).userType=='admin'){
            widgetContent = const AdminProfileWidget();
            appBarContent = "Admin Profile";
            _propertyListController.appBarContent.value = "Admin Profile";
            //appState.currentState = 1;
          }else{
            widgetContent = const AdminLoginWidget();
            appBarContent = "Admin Login";
            _propertyListController.appBarContent.value = "Admin Login";
            btmIcon = Icons.login;
            //appState.currentState = 1;
          }
        } else {
          widgetContent = const AdminLoginWidget();
          appBarContent = "Admin Login";
          _propertyListController.appBarContent.value = "Admin Login";
          //appState.currentState = 1;
        }
        break;
      case "EmployeeLoginWidget":
        if (myAppState(context).token.isNotEmpty && myAppState(context).userType.isNotEmpty) {
          if(myAppState(context).userType=='employee'){
            widgetContent = const EmployeeProfileWidget();
            appBarContent = "Employee Profile";
            _propertyListController.appBarContent.value = "Employee Profile";
            //appState.currentState = 1;
          }else{
            widgetContent = const EmployeeLoginWidget();
            appBarContent = "Employee Login";
            _propertyListController.appBarContent.value = "Employee Login";
            btmIcon = Icons.login;
            //appState.currentState = 1;
          }
        } else {
          widgetContent = const EmployeeLoginWidget();
          appBarContent = "Employee Login";
          _propertyListController.appBarContent.value = "Employee Login";
          //appState.currentState = 1;
        }
        break;  
      case "CustomerVisitRequestListPage":
        widgetContent = const CustomerVisitRequestListPage();
        appBarContent = "Customer Request";
        _propertyListController.appBarContent.value= "Customer Request";
        break;
      case "CustomerVisitRequestDetailPage":
        widgetContent = const CustomerVisitRequestDetailPage();
        appBarContent = "Request Detail";
        _propertyListController.appBarContent.value = "Request Detail";
      case "AddNewPropertyWidget":
        widgetContent = const AddNewPropertyWidget();
        appBarContent = "Add New Property";
        _propertyListController.appBarContent.value = "Add New Property";
        break;
      case "AddNewProjectWidget":
        widgetContent = const AddNewProjectWidget();
        appBarContent="Add New Project";
        _propertyListController.appBarContent.value = "Add New Project";
        break;
      case "SpacificErrorPage":
        widgetContent=const SpacificErrorPage();
        break;
      case "CustomerListPage":
        widgetContent=const CustomerListPage();
        appBarContent="Customer List";
        _propertyListController.appBarContent.value = "Customer List";
        break;
      case "CustomerDetailPage":
        widgetContent=CustomerDetailPage();
        appBarContent="Customer Details";
        _propertyListController.appBarContent.value = "Customer Details";
        break;
      case "EmployeeListPage":
        widgetContent = EmployeeListPage();
        appBarContent = "Employee List";
        _propertyListController.appBarContent.value = "Employee List";
        break;
      case "EmployeeDetailPage":
        widgetContent=EmployeeDetailPage();
        appBarContent = "Employee Details";
        _propertyListController.appBarContent.value = "Employee Detail";
        
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
      title:Obx((){return Text(
        _propertyListController.appBarContent.value,
        style: appbartitlestyle,
        softWrap: true,
      );}),
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
