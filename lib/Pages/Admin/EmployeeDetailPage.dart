import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
class EmployeeDetailPage extends StatefulWidget {
  const EmployeeDetailPage({super.key});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        appState.employeeDetails ={};
        appState.activeWidget="EmployeeListPage";
      },
      child: Container(
        color: Theme.of(context).primaryColorLight,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //=======================================PROFILE PIC
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white70,
                      child: appState.employeeDetails['profilePic']
                          .isNotEmpty
                          ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl:
                            '${ApiLinks.accessEmployeeProfilePic}/${appState.employeeDetails['profilePic']}',
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            // Other CachedNetworkImage properties
                          )
                      )
                          :const CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person,
                            size: 70, color: Colors.black),
                      ) ,
                    ),
                  ),
                ],
              ),
              //=========================================DETAIL CONTAINER
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                child: Column(
                  children: [
                    //==================================EMPLOYEE NAME
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Employee Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['name']}'
                        ),
                      ),
                    ),
                    
                    //==================================EMPLOYEE CONTACT
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color:
                              Theme.of(context).primaryColor,
                              size: MyConst
                                  .mediumSmallTextSize *
                                  fontSizeScaleFactor,
                            ),
                            const SizedBox(width: 4,),
                            const Text(
                              'Employee Mobile',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),],),
                        subtitle: Text(
                            '${appState.employeeDetails['mobile']}}'
                        ),
                      ),
                    ),
                    
                    //==================================EMPLOYEE EMAIL
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color:
                              Theme.of(context).primaryColor,
                              size: MyConst
                                  .mediumSmallTextSize *
                                  fontSizeScaleFactor,
                            ),
                            const SizedBox(width: 4,),
                            const Text(
                              'Employee Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['email']}}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE DOB
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Employee Date Of Birth',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['dob']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE BLOOD GROUP
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Blood Group',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['blood_group']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE EDUCATION
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Education',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['education']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE PROFESSION
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Profession',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['profession']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE INTEREST
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Interest',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['interest']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE FNAME
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Father Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['fname']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE MNAME
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Mother Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['mname']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE NOMINEE NAME
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Nominee Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['nominee_name']}'
                        ),
                      ),
                    ),

                    //==================================EMPLOYEE NOMINEE DOB
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Nominee Date of Birth',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['nominee_dob']}'
                        ),
                      ),
                    ),


                    //==================================EMPLOYEE NOMINEE RELATION
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Text(
                          'Relation',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                            '${appState.employeeDetails['relation']}'
                        ),
                      ),
                    ),
                    
                    //==================================EMPLOYEE ADDRESS
                    Card(
                      color: Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color:
                              Theme.of(context).primaryColor,
                              size: MyConst
                                  .mediumSmallTextSize *
                                  fontSizeScaleFactor,
                            ),
                            const SizedBox(width: 4,),
                            const Text(
                              'Address',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],),
                        subtitle: Text(
                            '${appState.employeeDetails['address']}, ${appState.employeeDetails['city']}, ${appState.employeeDetails['state']}, ${appState.employeeDetails['pincode']}'
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
