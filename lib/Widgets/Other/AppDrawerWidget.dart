
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Offer/OfferListPage.dart';
import 'package:real_state/Pages/StaticContentPage/WebViewPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/EmiCalculatorWidget.dart';
import 'package:real_state/Widgets/Other/FetchAdminContactWidget.dart';
import 'package:real_state/config/Constant.dart';
class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({Key? key}) : super(key: key);


  popNow(context){
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
      canPop: true,
        onPopInvoked: (didpop){
          appState.activeWidget='PropertyListWidget';
          appState.currentState=0;
        },
        child:Drawer(
          backgroundColor: Theme.of(context).primaryColorLight,
          elevation: 0,
          width: 270,
          shape: const RoundedRectangleBorder(
            // borderRadius: BorderRadius.only(
            //   topRight: Radius.circular(25),
            //   bottomRight: Radius.circular(25)
            // )
          ),
          shadowColor: Theme.of(context).primaryColorLight,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/ic_launcher.png',
                      height: 100,
                    ),
                    const Text(
                      'Y&K BUILDCON',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.home_outlined,color: Theme.of(context).primaryColor,),
                  title: const Text('Home'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='PropertyListWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.local_offer_outlined,color: Theme.of(context).primaryColor,),
                  title: const Text('Offers'),
                  onTap: () {
                    popNow(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const OfferListPage()));
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.calculate_outlined,color: Theme.of(context).primaryColor),
                  title: const Text('EMI Calculator'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const EmiCalculatorWidget()));
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.business_outlined,color: Theme.of(context).primaryColor),
                  title: const Text('Future Of Colony'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='PropertyListWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.chat_outlined,color: Theme.of(context).primaryColor),
                  title: const Text('Customer Inquery'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='PropertyListWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.post_add_outlined,color: Theme.of(context).primaryColor),
                  title: const Text('Blog Post'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewPage()));
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.support_agent_outlined,color: Theme.of(context).primaryColor),
                  title: const Text('Contact Support'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const FetchAdminContactWidget()));
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.support_agent_outlined,color: Theme.of(context).primaryColor),
                  title: const Text('Admin Pannel'),
                  onTap: () {
                    Navigator.of(context).pop();// Close the drawer
                    appState.activeWidget='AdminLoginWidget';
                    appState.currentState=1;

                  },
                ),
              ),

            ],
          ),
        )
    );

  }
}
