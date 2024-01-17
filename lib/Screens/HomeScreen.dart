import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Admin/CustomerVisitRequestDetailPage.dart';
import 'package:real_state/Pages/Customer/FavoritePropertyDetailPage.dart';
import 'package:real_state/Pages/Customer/VisitRequestedDetailPage.dart';
import 'package:real_state/Pages/Property/PropertyDetailPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Admin/AddNewPropertyWidget.dart';
import 'package:real_state/Widgets/Admin/AdminLoginWidget.dart';
import 'package:real_state/Widgets/Admin/AdminProfileWidget.dart';
import 'package:real_state/Widgets/Admin/CustomerVisitRequestListWidget.dart';
import 'package:real_state/Widgets/Customer/FavoritePropertyListWidget.dart';
import 'package:real_state/Widgets/Customer/LoginWidget.dart';
import 'package:real_state/Widgets/Customer/ProfileWidget.dart';
import 'package:real_state/Widgets/Customer/SignupWidget.dart';
import 'package:real_state/Widgets/Customer/VisitRequestedListWidget.dart';
import 'package:real_state/Widgets/Other/AppDrawerWidget.dart';
import 'package:real_state/Widgets/Other/EmiCalculatorWidget.dart';
import 'package:real_state/Widgets/Property/PropertyListWidget.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

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
      } else {
        url = Uri.parse(ApiLinks.customerProfile);
      }
      StaticMethod.userProfileInitial(appState.token, url, appState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);

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
    Widget widgetContent = const LoginWidget();
    String appBarContent = 'Y&K BUILDCON';
    switch (appState.activeWidget) {
      case "PropertyListWidget":
        widgetContent = const PropertyListWidget();
        appBarContent = 'Y&K BUILDCON';
        break;
      case "LoginWidget":
        if (appState.userType.isNotEmpty && appState.token.isNotEmpty) {
          if (appState.userType == "admin") {
            widgetContent = const AdminProfileWidget();
            appBarContent = "Admin Profile";
          } else {
            widgetContent = const ProfileWidget();
            appBarContent = "Customer Profile";
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
        appBarContent = 'Registration';
        secondBtmContent = 'registration';
        btmIcon = Icons.person_add;
      case "ProfileWidget":
        if (appState.userType == "admin") {
          widgetContent = const AdminProfileWidget();
        } else {
          widgetContent = const ProfileWidget();
        }
        secondBtmContent = 'Profile';
        btmIcon = Icons.person;
        if (appState.userType == "admin") {
          appBarContent = "Admin Profile";
        } else {
          appBarContent = "Profile";
        }
        break;
      case "PropertyDetailPage":
        widgetContent = const PropertyDetailPage();
        appBarContent = 'Property Details';
        break;
      case "FavoritePropertyDetailPage":
        widgetContent = const FavoritePropertyDetailPage();
        appBarContent = 'Your Favorite Property';
        break;
      case "FavoritePropertyListWidget":
        widgetContent = const FavoritePropertyListWidget();
        appBarContent = "Favorite List";
        break;
      case "VisitRequestedListWidget":
        widgetContent = const VisitRequestedListWidget();
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
            appState.currentState = 1;
          }else{
            widgetContent = const AdminLoginWidget();
            appBarContent = "Admin Login";
            secondBtmContent = "Login";
            btmIcon = Icons.login;
          }
        } else {
          widgetContent = const AdminLoginWidget();
          appBarContent = "Admin Login";
        }
        break;
      case "CustomerVisitRequestListWidget":
        widgetContent = const CustomerVisitRequestListWidget();
        appBarContent = "Customer Request";
        break;
      case "CustomerVisitRequestDetailPage":
        widgetContent = const CustomerVisitRequestDetailPage();
        appBarContent = "Request Detail";
      case "AddNewPropertyWidget":
        widgetContent = const AddNewPropertyWidget();
        appBarContent = "Add New Property";
        break;
    }
    return PopScope(
        canPop: false,
        onPopInvoked:(didPop) {

          switch (appState.activeWidget) {
            case "PropertyDetailPage":
              appState.activeWidget = "PropertyListWidget";
              appState.selectedProperty = {};
              appState.addedToFavorite = false;
              break;
            case "FavoritePropertyDetailPage":
              appState.activeWidget = "FavoritePropertyListWidget";
              appState.selectedProperty = {};
              appState.addedToFavorite = false;
              break;
            case "FavoritePropertyListWidget":
              appState.activeWidget = "ProfileWidget";
              break;
            case "VisitRequestedDetailPage":
              appState.activeWidget = "VisitRequestedListWidget";
              appState.selectedProperty = {};
              appState.addedToFavorite = false;
              break;
            case "VisitRequestedListWidget":
              appState.activeWidget = "ProfileWidget";
              break;
            case "EmiCalculatorWidget":
              appState.activeWidget = "PropertyListWidget";
              break;
            case "CustomerVisitRequestDetailPage":
              appState.activeWidget = "CustomerVisitRequestListWidget";
              appState.addedToFavorite=false;
              break;
            case "CustomerVisitRequestListWidget":
              appState.activeWidget = "ProfileWidget";
              break;
            case "AddNewPropertyWidget":
              appState.activeWidget = "ProfileWidget";
              break;

          }

        },
      child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 10,
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    color: Theme.of(context).primaryColor,
                  ),

                  Expanded(
                    child: Text(
                      appBarContent,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  //topRight: Radius.circular(50)
                ),
              ),
              actions: [darkModeAction],
              backgroundColor: Theme.of(context).hintColor,
            ),
            body: widgetContent,
            bottomNavigationBar: BottomNavigationBar(
              iconSize: 20,
              selectedIconTheme: const IconThemeData(
                size: 30,
              ),
              selectedFontSize: 15,
              selectedItemColor: Theme.of(context).hintColor,
              unselectedItemColor: Colors.grey,
              currentIndex: appState.currentState,
              onTap: (index) async {
                //setState(() {
                appState.currentState = index;
                switch (index) {
                  case 0:
                    appState.activeWidget = 'PropertyListWidget';
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
            drawer: const AppDrawerWidget(),
          )),
        );
  }
}
