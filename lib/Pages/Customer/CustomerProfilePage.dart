import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/ImagePickerPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({Key? key}) : super(key: key);

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
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
                    backgroundImage: appState.customerDetails['c_profilePic'].length > 0
                        ? CachedNetworkImageProvider(
                      '${ApiLinks.accessCustomerProfilePic}/${appState.customerDetails['c_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                    )
                        : null, // Set to null if there is no profile picture
                    child: appState.customerDetails['c_profilePic'].isEmpty
                        ? const Icon(Icons.person,
                            size: 70,
                            color: Colors
                                .black) // Centered icon when no profile picture
                        : null, // No child when there is a profile picture, since it's set as backgroundImage
                  ),
                ),
                Positioned(
                    bottom: 20,
                    right: 10,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Theme.of(context).hintColor,
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImagePickerPage(
                                          userDetails: appState.customerDetails,
                                          forWhich: 'customerProfilePic',
                                        )));
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 15,
                            color: Theme.of(context).primaryColor,
                          )),
                    ))
              ],
            ),

            //------------------------------------------Name
            Text(
                '${appState.customerDetails['c_name']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            //------------------------------------------Email
            Text(
                '${appState.customerDetails['c_email']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),

            //------------------------------------------mobile
            Text(
                '${appState.customerDetails['c_mobile']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),


            //------------------------------------------edit btn
            Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 4),
                    onPressed: () {},
                    child: Text(
                      'Edit Details',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ))),
            const SizedBox(
              height: 20,
            ),

            //-----------------------------------------your visit request
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.07,
              child: Card(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    const Icon(Icons.book_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text('Your Visit Request'),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          appState.activeWidget = "VisitRequestedListWidget";
                        },
                        icon: const Icon(
                          Icons.arrow_right,
                          size: 40,
                        ))
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            //----------------------------------------your favorite property
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.07,
              child: Card(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    const Icon(Icons.favorite_outline),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text('Your Favorite Properties'),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          appState.activeWidget = "FavoritePropertyListWidget";
                        },
                        icon: const Icon(
                          Icons.arrow_right,
                          size: 40,
                        ))
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            //----------------------------------------logout btn
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
                child: InkWell(
                  onTap: () {
                    StaticMethod.logout(appState);
                  },
                  child: const Card(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.logout_sharp),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Log Out from your account',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

//   ${ApiLinks.accessCustomerProfilePic}/${appState.customerDetails['c_profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}
