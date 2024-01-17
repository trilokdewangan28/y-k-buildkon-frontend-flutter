import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/ImagePickerPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';


class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //-------------------------------------------profile pic and edit btn
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: appState.adminDetails['ad_profilePic'].length > 0
                        ? NetworkImage(
                      '${ApiLinks.accessAdminProfilePic}/${appState.adminDetails['ad_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                    )
                        : null, // Set to null if there is no profile picture
                    child: appState.adminDetails['ad_profilePic'].isEmpty
                        ? const Icon(Icons.person, size: 70, color: Colors.black) // Centered icon when no profile picture
                        : null, // No child when there is a profile picture, since it's set as backgroundImage
                  ),
                ),
                Positioned(
                    bottom: 20,
                    right: 10,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Theme.of(context).hintColor,
                      child:
                      IconButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagePickerPage(userDetails: appState.adminDetails,forWhich: 'adminProfilePic',)));
                      }, icon: Icon(Icons.edit, size: 15, color: Theme.of(context).primaryColor,)),
                    ))
              ],
            ),

            //------------------------------------------Name
            Text(
                '${appState.adminDetails['ad_name'].toUpperCase()} (ADMIN)',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),

            //------------------------------------------Email
             Text(
                '${appState.adminDetails['ad_email']}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                ),
              ),

            //------------------------------------------mobile
             Text(
                '${appState.adminDetails['ad_mobile']}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                ),
              ),


            //------------------------------------------edit btn
            Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                        elevation: 4
                    ),
                    onPressed: (){},
                    child: Text('Edit Details',style: TextStyle(color: Theme.of(context).hintColor),)
                )
            ),
            const SizedBox(height: 20,),

            //-----------------------------------------customer visit request
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.height*0.07,
              child: InkWell(
                onTap: (){
                  appState.activeWidget="CustomerVisitRequestListWidget";
                  appState.currentState=1;
                },
                child: const Card(
                  child: Row(
                    children: [
                      SizedBox(width: 15,),
                      Icon(Icons.book_outlined),
                      SizedBox(width: 15,),
                      Text('Customer Visit Request'),
                    ],
                  ),
                ),
              )
            ),

            const SizedBox(height: 15,),

            //----------------------------------------customer payment history
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              //width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.height*0.07,
              child: InkWell(
                onTap: (){},
                child:const Card(
                  child: Row(
                    children: [
                      SizedBox(width: 15,),
                      Icon(Icons.payment),
                      SizedBox(width: 15,),
                      Text('Customer Payment History'),
                    ],
                  ),
                ),
              )
            ),

            const SizedBox(height: 15,),

            //----------------------------------------sold property list
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
             // width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.height*0.07,
              child: InkWell(
                onTap: (){},
                child: const Card(
                  child: Row(
                    children: [
                      SizedBox(width: 15,),
                      Icon(Icons.business),
                      SizedBox(width: 15,),
                      Text('sold property list'),
                    ],
                  ),
                ),
              )
            ),
            const SizedBox(height: 15,),

            //----------------------------------------LIST NEW PROPERTY
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.07,
                child: InkWell(
                  onTap: (){
                    appState.activeWidget = "AddNewPropertyWidget";
                  },
                  child: const Card(
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(Icons.add_business),
                        SizedBox(width: 15,),
                        Text('Add New Property'),
                      ],
                    ),
                  ),
                )
            ),
            const SizedBox(height: 15,),

            //----------------------------------------logout btn
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
               // width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.07,
                child: InkWell(
                  onTap: ()async{
                    //StaticMethod.logout(appState);
                    appState.deleteToken(appState.userType);
                    appState.token="";
                    await Future.delayed(
                        const Duration(milliseconds: 100)); // Add a small delay (100 milliseconds)

                    appState.deleteUserType();
                    appState.userType="";
                    await Future.delayed(const Duration(milliseconds: 100));

                    appState.customerDetails = {};
                    appState.customerDetails.clear();
                    appState.adminDetails={};
                    appState.adminDetails.clear();
                    await Future.delayed(const Duration(milliseconds: 100));

                    appState.activeWidget = "PropertyListWidget";
                    appState.currentState=0;

                    await appState.fetchUserType();
                    Future.delayed(const Duration(milliseconds: 100));

                    appState.fetchToken(appState.userType);
                    Future.delayed(const Duration(milliseconds: 100));
                  },
                  child: const Card(
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(Icons.logout_sharp),
                        SizedBox(width: 15,),
                        Text('Log Out from your account', style: TextStyle(color: Colors.red),),
                      ],
                    ),
                  ),
                )
            )

          ],
        ),
      ),
    );
  }
}
