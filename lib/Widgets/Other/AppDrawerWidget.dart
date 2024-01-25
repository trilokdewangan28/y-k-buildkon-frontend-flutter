
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/FetchAdminContactWidget.dart';
class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return PopScope(
       onPopInvoked: (didPop) {
         appState.activeWidget='HomeWidget';
         appState.currentState=0;
         Navigator.pop(context);
       },
        child:Drawer(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          width: 270,
          shape: const RoundedRectangleBorder(
            // borderRadius: BorderRadius.only(
            //   topRight: Radius.circular(25),
            //   bottomRight: Radius.circular(25)
            // )
          ),
          shadowColor: Theme.of(context).primaryColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      color: Theme.of(context).hintColor,
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
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.home,color: Theme.of(context).hintColor,),
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
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.local_offer_outlined,color: Theme.of(context).hintColor,),
                  title: const Text('Offers'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='HomeWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.calculate_rounded,color: Theme.of(context).hintColor),
                  title: const Text('EMI Calculator'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='EmiCalculatorWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.business,color: Theme.of(context).hintColor),
                  title: const Text('Future Of Colony'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='HomeWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.chat_outlined,color: Theme.of(context).hintColor),
                  title: const Text('Customer Inquery'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='HomeWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.landscape_outlined,color: Theme.of(context).hintColor),
                  title: const Text('Bhuiya App'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='HomeWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.post_add,color: Theme.of(context).hintColor),
                  title: const Text('Blog Post'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='HomeWidget';
                    appState.currentState=0;
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.support_agent_outlined,color: Theme.of(context).hintColor),
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
                color: Theme.of(context).primaryColor,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: Icon(Icons.support_agent_outlined,color: Theme.of(context).hintColor),
                  title: const Text('Admin Pannel'),
                  onTap: () {
                    Navigator.pop(context);// Close the drawer
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
