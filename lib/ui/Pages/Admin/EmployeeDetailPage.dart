import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';
class EmployeeDetailPage extends StatefulWidget {
  const EmployeeDetailPage({super.key});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  Color statusColor = Colors.orange;
  List<String> employeeStatus = ['Newly Applied','Rejected','Joined','Leaved'];
  String selectedEmployeeStatus = "Newly Applied";

  _changeEmployeeStatus(data,appState,context)async{
    var url = Uri.parse(ApiLinks.changeEmployeeStatus);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>  Center(
        child:StaticMethod.progressIndicator()
      ),
    );
    final res = await StaticMethod.changeEmployeeStatus(appState.token, data, url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget = "EmployeeListPage";
      }else{
        print(res['error']);
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    if(appState.employeeDetails['status']=="Newly Applied"){
      statusColor = Colors.orange;
    }else if(appState.employeeDetails['status']=='Rejected'){
      statusColor=Colors.red;
    }else if(appState.employeeDetails['status']=='Joined'){
      statusColor = Colors.green;
    }else if(appState.employeeDetails['status']=='Leaved'){
      statusColor = Colors.red;
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        appState.employeeDetails ={};
        appState.activeWidget="EmployeeListPage";
      },
      child: Container(
        color: Theme.of(context).colorScheme.surface,
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
                            placeholder: (context, url) => StaticMethod.progressIndicator(),
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color:
                              Get.isDarkMode?Colors.white70 : Theme.of(context).primaryColor,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color:
                              Get.isDarkMode ? Colors.white70 :Theme.of(context).primaryColor,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
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
                    ),

                    //==================================EMPLOYEE STATUS
                    Card(
                      color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
                      child: ListTile(
                        title: const Row(
                          children: [
                             Text(
                              'Status',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],),
                        subtitle: Text(
                            '${appState.employeeDetails['status']}',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w500
                          ),
                          
                        ),
                      ),
                    ),


                    //==============================CHANGE PROPERTY STATUS BUTTON
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Get.isDarkMode?Colors.white70:Colors.black),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            appState.userType=='admin'
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Marked As:'),
                                const SizedBox(width: 4,),
                                //==========================================DROPDOWN CARD
                                Card(
                                    color: Get.isDarkMode ? Colors.white12 :Theme.of(context).primaryColorLight,
                                    elevation: 1,
                                    child: Container(
                                        height: MyConst.deviceWidth(context)*0.1,
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: selectedEmployeeStatus,
                                            alignment: Alignment.center,
                                            elevation: 16,
                                            underline: Container(),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                selectedEmployeeStatus = value!;
                                                //print('selected property type is ${selectedPropertyType}');
                                              });
                                            },
                                            ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                            items: employeeStatus
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value,
                                                        softWrap: true,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: MyConst.smallTextSize*fontSizeScaleFactor,
                                                            overflow: TextOverflow
                                                                .ellipsis)),
                                                  );
                                                }).toList(),
                                          ),
                                        )
                                    )
                                ),
                                const SizedBox(width: 4,),
                              ],
                            )
                                : Container(),
                            //==========================================SUBMIT BUTTON
                            Container(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      backgroundColor: bluishClr
                                  ),
                                  onPressed: appState.employeeDetails['status']==selectedEmployeeStatus
                                      ? null
                                      :  (){
                                    var data = {
                                      "newStatus":selectedEmployeeStatus,
                                      "employee_id":appState.employeeDetails['employee_id']
                                    };
                                    _changeEmployeeStatus(data, appState, context);
                                  },
                                  child:Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.w600
                                    ),
                                  )
                              ),
                            )
                          ],
                        )
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
