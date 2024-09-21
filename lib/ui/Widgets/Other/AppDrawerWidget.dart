
import 'package:JAY_BUILDCON/ui/Screens/payment_qr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';
import 'package:JAY_BUILDCON/ui/Pages/Offer/OfferListPage.dart';
import 'package:JAY_BUILDCON/ui/Pages/StaticContentPage/AdminContactPage.dart';
import 'package:JAY_BUILDCON/ui/Pages/StaticContentPage/BlogListPage.dart';
import 'package:JAY_BUILDCON/ui/Widgets/Other/EmiCalculatorWidget.dart';
import 'package:JAY_BUILDCON/ui/Widgets/Property/ProjectLisWidget.dart';
class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});


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
          appState.activeWidget='PropertyListPage';
          appState.currentState=0;
        },
        child:Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
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
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/ic_launcher.png',
                      height: 130,
                    ),
                    // const Text(
                    //   'JAY BUILDCON',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 20,
                    //   ),
                    // ),
                  ],
                )
              ),
              
              //==========================================HOME TILE
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Colors.white,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.home_outlined,color:bluishClr,),
                  title: const Text('Home'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget='PropertyListPage';
                    appState.currentState=0;
                  },
                ),
              ),

              //==========================================PROJECTS TILE
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.apartment_outlined,color:bluishClr,),
                  title: const Text('Project'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProjectListWidget()));
                  },
                ),
              ),
              
              //==========================================OFFER TILE
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.local_offer_outlined, color:bluishClr,),
                  title: const Text('Offers'),
                  onTap: () {
                    //popNow(context);
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> OfferListPage(fromWidget: appState.activeWidget,)));
                  },
                ),
              ),
              
              //==========================================EMI CALCULATOR TILE
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.calculate_outlined,color:bluishClr),
                  title: const Text('EMI Calculator'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const EmiCalculatorWidget()));
                  },
                ),
              ),
              
              //==========================================FUTURE OF COLONY
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.business_sharp,color:bluishClr),
                  title: const Text('Payment Option'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentQr()));

                  },
                ),
              ),
              
              //==========================================BLOG POST
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.post_add_outlined,color:bluishClr),
                  title: const Text('Blog Post'),
                  onTap: () {
                    // Handle the onTap action for the Home item
                    Navigator.pop(context);// Close the drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const BlogListPage()));
                  },
                ),
              ),
              
              //==========================================CONTACT SUPPORT
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color:Get.isDarkMode?Colors.white30:  Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.support_agent_outlined,color:bluishClr),
                  title: const Text('Contact Support'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(()=>const AdminContactPage());
                    appState.currentState=0;
                  },
                ),
              ),

              //==========================================EMPLOYEE JOIN
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.person_add_alt_outlined,color:bluishClr),
                  title: const Text('Membership Join'),
                  onTap: () {
                    Navigator.pop(context);// Close the drawer
                    appState.activeWidget = "EmployeeLoginWidget";
                    appState.currentState = 1;
                  },
                ),
              ),
              
              //==========================================ADMIN PANEL
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                color: Get.isDarkMode?Colors.white30: Theme.of(context).primaryColorLight,
                shadowColor: Colors.black,
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined,color:bluishClr),
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
