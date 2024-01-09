import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Property/FavoritePropertyDetailPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
class VisitRequestedDetailPage extends StatefulWidget {
  const VisitRequestedDetailPage({Key? key}) : super(key: key);

  @override
  State<VisitRequestedDetailPage> createState() => _VisitRequestedDetailPageState();
}

class _VisitRequestedDetailPageState extends State<VisitRequestedDetailPage> {
  bookVisit(requestData,appState,context)async{

    var url = Uri.parse(ApiLinks.requestVisit);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.requestVisit(requestData,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }
  addToFavorite(data,appState, context)async{
    var url = Uri.parse(ApiLinks.addToFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.addToFavorite(data,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
        fetchFavoriteProperty(appState);
        setState(() {
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }
  removeFromFavorite(data,appState,context)async{
    var url = Uri.parse(ApiLinks.removeFromFavorite);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.removeFromFavorite(data, url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
        fetchFavoriteProperty(appState);
        setState(() {
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }
  fetchFavoriteProperty(appState)async{
    var data = {
      "c_id":appState.customerDetails['c_id'],
      "p_id":appState.selectedVisitRequestedProperty['p_id']
    };
    var url = Uri.parse(ApiLinks.fetchFavoriteProperty);
    final res = await StaticMethod.fetchFavoriteProperty(data,url);
    if(res.isNotEmpty){
      if(res['success']==true){
        print(res);
        if(res['result'].length>0){
          appState.addedToFavorite = true;
          setState(() {
          });
        }else{
          appState.addedToFavorite = false;
          setState(() {
          });
        }
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
      }else{
        appState.addedToFavorite = false;
        setState(() {

        });
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }
  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    fetchFavoriteProperty(appState);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //--------------------------------property images
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/images/home.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                          onPressed: (){
                            if(appState.customerDetails.isNotEmpty){
                              print(appState.customerDetails);
                              var data={
                                "c_id":appState.customerDetails['c_id'],
                                "p_id":appState.selectedVisitRequestedProperty['p_id']
                              };

                              appState.addedToFavorite==false ? addToFavorite(data,appState, context) : removeFromFavorite(data, appState, context);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('you have to login. please login', style: TextStyle(color: Colors.red),)));
                            }
                          },
                          icon: appState.addedToFavorite==false ?  Icon(Icons.favorite_outline) : Icon(Icons.favorite, color: Colors.red,)
                      )
                    ],
                  )
              ),

              //-------------------------------property detail card

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${appState.selectedVisitRequestedProperty['p_name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.star, color: Colors.green,),
                    Text('4.5')
                  ],
                ),
              ),     //---------name and rating

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Theme.of(context).hintColor,),
                    Text(
                        '${appState.selectedVisitRequestedProperty['p_address']}, ${appState.selectedVisitRequestedProperty['p_locality']} , ${appState.selectedVisitRequestedProperty['p_city']}'
                    )
                  ],
                ),
              ),     //---------address

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${appState.selectedVisitRequestedProperty['p_price']} ₹',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor
                      ),
                    )
                  ],
                ),
              ),     //-----------price

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Square Foot',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                          ),
                        ),
                        Text('${appState.selectedVisitRequestedProperty['p_area']}')
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text('Bedroom',style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                        ),),
                        Text('${appState.selectedVisitRequestedProperty['p_bedroom']}')
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text('Bathroom',style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                        ),),
                        Text('${appState.selectedVisitRequestedProperty['p_bathroom']}')
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text('Hall',style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                        ),),
                        Text('${appState.selectedVisitRequestedProperty['p_hall']}')
                      ],
                    )
                  ],
                ),
              ),   //----- spacification

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                child: Text(
                  'About Property',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                  ),
                ),
              ),   //------- about property heading

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                child: Text(
                  '${appState.selectedVisitRequestedProperty['p_desc']}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15
                  ),
                  softWrap: true,
                ),
              ),   //------- about property detail

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                child: Text(
                  'Location',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                  ),
                ),
              ),  //----------- location heading

              //------------------------------map view
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: InkWell(
                    highlightColor: Theme.of(context).primaryColorDark,
                    onTap: () {
                      print('map url is ${appState.selectedVisitRequestedProperty['p_locationurl']}');
                      StaticMethod.openMap(appState.selectedVisitRequestedProperty['p_locationurl']);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/images/map.jpg',
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                      ),
                    ),
                  )),

              //-------------------------------buttons book , contact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child:
                    ElevatedButton(
                        onPressed: () {
                          var requestData = {
                            "c_id":appState.customerDetails['c_id'],
                            "p_id":appState.selectedVisitRequestedProperty['p_id']
                          };
                          print(requestData);
                          appState.customerDetails!={}
                              ? bookVisit(requestData, appState, context)
                              : ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('to request for visit, you have to login. please login', style: TextStyle(color: Colors.red),)));
                        },
                        child: Text('Book Visit', style: TextStyle(color: Theme.of(context).hintColor),)
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                          onPressed: () {}, child: Text('Contact Now',style: TextStyle(color: Theme.of(context).hintColor),))),
                ],
              )
            ],
          ),
        ));
  }
}
