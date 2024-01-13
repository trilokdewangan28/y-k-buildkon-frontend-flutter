import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/ImagePickerPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Customer/ProfileWidget.dart';
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
      decoration: BoxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //-------------------------------------------profile pic and edit btn
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: appState.adminDetails['ad_profilePic'].length > 0
                        ? NetworkImage(
                      '${ApiLinks.accessAdminProfilePic}/${appState.adminDetails['ad_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                    )
                        : null, // Set to null if there is no profile picture
                    child: appState.adminDetails['ad_profilePic'].isEmpty
                        ? Icon(Icons.person, size: 70, color: Colors.black) // Centered icon when no profile picture
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagePickerPage(userDetails: appState.adminDetails,forWhich: 'profilePic',)));
                      }, icon: Icon(Icons.edit, size: 15, color: Theme.of(context).primaryColor,)),
                    ))
              ],
            ),

            //------------------------------------------Name
            Container(
              child: Text(
                '${appState.adminDetails['ad_name']}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            //------------------------------------------Email
            Container(
              child: Text(
                '${appState.adminDetails['ad_email']}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),

            //------------------------------------------mobile
            Container(
              child: Text(
                '${appState.adminDetails['ad_mobile']}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),


            //------------------------------------------edit btn
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                        elevation: 4
                    ),
                    onPressed: (){},
                    child: Text('Edit Details',style: TextStyle(color: Theme.of(context).hintColor),)
                )
            ),
            SizedBox(height: 20,),

            //-----------------------------------------customer visit request
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              // width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.height*0.07,
              child: InkWell(
                onTap: (){
                  appState.activeWidget="CustomerVisitRequestListWidget";
                  appState.currentState=1;
                },
                child: Card(
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

            SizedBox(height: 15,),

            //----------------------------------------customer payment history
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              //width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.height*0.07,
              child: InkWell(
                onTap: (){},
                child:Card(
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

            SizedBox(height: 15,),

            //----------------------------------------sold property list
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
             // width: MediaQuery.of(context).size.width*0.85,
              height: MediaQuery.of(context).size.height*0.07,
              child: InkWell(
                onTap: (){},
                child: Card(
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

            SizedBox(height: 15,),

            //----------------------------------------logout btn
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
               // width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.07,
                child: InkWell(
                  onTap: (){
                    StaticMethod.logout(appState);
                  },
                  child: Card(
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
