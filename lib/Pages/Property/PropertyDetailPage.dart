import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Property/ImageSlider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/FetchAdminContactWidget.dart';
import 'package:real_state/Widgets/RatingDisplayWidget.dart';
import 'package:real_state/Widgets/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({Key? key}) : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {

  //==================================BOOK VISIT
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

  //==================================ADD TO FAVORITE
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

  //==================================REMOVE FROM FAVORITE
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

  //==================================FETCH FAVORITE PROPERTY
  fetchFavoriteProperty(appState)async{
    var data = {
      "c_id":appState.customerDetails['c_id'],
      "p_id":appState.selectedProperty['p_id']
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

  //===================================SUBMIT PROPERTY RATING
  submitPropertyRating(data,appState, btmSheetContext)async{
    var url = Uri.parse(ApiLinks.submitPropertyRating);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final response = await StaticMethod.submitPropertyRating(data,url);
    Navigator.pop(context);
    if (response.isNotEmpty) {
      if(response['success']==true){
        Navigator.pop(btmSheetContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response['message']}', style: TextStyle(color: Colors.green),)));
      }else{
        Navigator.pop(btmSheetContext);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response['message']}', style: TextStyle(color: Colors.red),)));
      }
    }
  }

  //===================================SUBMIT FEEDBACK & RATING BTMST
  void _showBottomSheetForSubmitRating(BuildContext context, appState) {
    final _feedbackController = TextEditingController();
    int rateValue = 0;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context)=>StatefulBuilder(
            builder: (context,setState){
              return SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding:
                    EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'select your rating',
                          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        //--------------------------------------------RATING CONTAINER
                        Container(
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rateValue = 1;
                                      });
                                      print(rateValue);
                                    },
                                    icon: rateValue >= 1
                                        ? const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    )
                                        : const Icon(Icons.star_border_outlined)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rateValue = 2;
                                      });
                                      print(rateValue);
                                    },
                                    icon: rateValue >= 2
                                        ? const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    )
                                        : const Icon(Icons.star_border_outlined)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rateValue = 3;
                                      });
                                      print(rateValue);
                                    },
                                    icon: rateValue >= 3
                                        ? const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    )
                                        : const Icon(Icons.star_border_outlined)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rateValue = 4;
                                      });
                                      print(rateValue);
                                    },
                                    icon: rateValue >= 4
                                        ? const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    )
                                        : const Icon(Icons.star_border_outlined)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rateValue = 5;
                                      });
                                      print(rateValue);
                                    },
                                    icon: rateValue == 5
                                        ? const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    )
                                        : const Icon(Icons.star_border_outlined)),
                              ],
                            )),
                        //---------------------------------------FEEDBACK CONTAINER
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: TextField(
                            controller: _feedbackController,
                            maxLines: null, // Allows an unlimited number of lines
                            decoration: InputDecoration(
                              labelText: 'Enter your feedback...',
                              hintText: 'Enter your feedback here...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                        //--------------------------------------------------SUBMIT NOW
                        ElevatedButton(
                            onPressed: () {
                              var data = {
                                "c_id":appState.customerDetails['c_id'],
                                "p_id":appState.selectedProperty['p_id'],
                                "feedback":_feedbackController.text,
                                "rating":rateValue
                              };
                              submitPropertyRating(data, appState,context);
                            },
                            child: const Text('submit'))
                      ],
                    ),
                  ));
            }
        )
    );
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
          //===========================PROPERTY IMAGES
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Stack(
              children: [
                ClipRRect(

                  child: appState.selectedProperty['pi_name'].length != 0
                      ? Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ImageSlider(
                      propertyData: appState.selectedProperty,
                      asFinder: true,
                    ),
                  )
                      : Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25)),
                    child: const Center(child: Text('no image found')),
                  )
                ),
              ],
            )
          ),


          //===========================PROPERTY DETAIL SECTION
          //================================== ROW 1
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
            child: Row(
              children: [
                //================================NAME
                Expanded(child: Container(
                  child: Text(
                    '${appState.selectedProperty['p_name'].toUpperCase()}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                    ),
                    softWrap: true,
                  ),
                ),),
                SizedBox(width: 10,),

                //================================RATINGS
                InkWell(
                  onTap: (){
                    _showBottomSheetForSubmitRating(context, appState);
                  },
                  child: RatingDisplayWidgetTwo(rating: appState.selectedProperty['p_rating'].toDouble())
                ),
                //================================RATING USER COUNT
                Text(
                    '(${appState.selectedProperty['p_rating_count']})'
                )

              ],
            ),
          ),

          //==================================ROW 2
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
            child: Row(
              children: [
                //============================LOCATION
                Icon(Icons.location_on_outlined, color: Theme.of(context).hintColor,),
                Expanded(child: Container(
                  child: Text(
                      '${appState.selectedProperty['p_address']}, ${appState.selectedProperty['p_locality']} , ${appState.selectedProperty['p_city']}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14
                    ),
                    softWrap: true,
                  ),
                ))
              ],
            ),
          ),

          //==================================ROW 3
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
            child: Row(
              children: [
                //=============================PRICE
                Text(
                    '${appState.selectedProperty['p_price']} ₹',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).hintColor
                  ),
                ),
                Spacer(),
                //=============================FAVRITE BTN
                IconButton(
                    onPressed: (){
                      if(appState.customerDetails.isNotEmpty){
                        print(appState.customerDetails);
                        var data={
                          "c_id":appState.customerDetails['c_id'],
                          "p_id":appState.selectedProperty['p_id']
                        };

                        appState.addedToFavorite==false ? addToFavorite(data,appState, context) : removeFromFavorite(data, appState, context);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('you have to login. please login', style: TextStyle(color: Colors.red),)));
                      }
                    },
                    icon: appState.addedToFavorite==false ?  Icon(Icons.favorite_outline) : Icon(Icons.favorite, color: Colors.red,)
                ),
              ],
            ),
          ),     //-----------price

          SizedBox(height: 10,),
          //=================================ROW 4
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //===================================SQUARE FEET
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
                    Icon(Icons.square_foot, color: Theme.of(context).hintColor,),
                    Text('${appState.selectedProperty['p_area']}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15
                      ),)
                  ],
                ),
                SizedBox(width: 20,),
                //===================================BEDROOM
                Column(
                  children: [
                    Text('Bedroom',style: TextStyle(
                        fontWeight: FontWeight.w600,
                      fontSize: 15
                    ),),
                    Icon(Icons.bedroom_parent,color: Theme.of(context).hintColor,),
                    Text('${appState.selectedProperty['p_bedroom']}',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ))
                  ],
                ),
                SizedBox(width: 20,),
                //===================================BATHROOM
                Column(
                  children: [
                    Text('Bathroom',style: TextStyle(
                        fontWeight: FontWeight.w600,
                      fontSize: 15
                    ),),
                    Icon(Icons.bathroom,color: Theme.of(context).hintColor,),
                    Text('${appState.selectedProperty['p_bathroom']}',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ))
                  ],
                ),
                SizedBox(width: 20,),
                //====================================HALL
                Column(
                  children: [
                    Text('Hall',style: TextStyle(
                        fontWeight: FontWeight.w600,
                      fontSize: 15
                    ),),
                    Icon(Icons.living,color: Theme.of(context).hintColor,),
                    Text('${appState.selectedProperty['p_hall']}',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ))
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10,),

          //==========================================PROPERTY DESCRIPTION
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
            child: Text(
              'About Property',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
            child: Text(
              'afdkljaskldfjasdjfklasjdflkjasdklfjalskdjflk;asdjflkasjdfkljasdlk;fjasldkfjkakl;sdjfl;kasdjfklajsdklf;jasldfjasldkjflkasdjf',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.grey
              ),
              softWrap: true,
            ),
          ),
          SizedBox(height: 10,),

          //==========================================LOCATION MAP
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
            child: Text(
              'Location',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: InkWell(
                highlightColor: Theme.of(context).primaryColorDark,
                onTap: () {
                  print('map url is ${appState.selectedProperty['p_locationurl']}');
                  StaticMethod.openMap(appState.selectedProperty['p_locationurl']);
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

          //===========================================BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).hintColor,
                        foregroundColor: Theme.of(context).primaryColor
                      ),
                        onPressed: () {
                          var requestData = {
                            "c_id":appState.customerDetails['c_id'],
                            "p_id":appState.selectedProperty['p_id']
                          };
                          print(requestData);
                         appState.customerDetails!={}
                         ? bookVisit(requestData, appState, context)
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('to request for visit, you have to login. please login', style: TextStyle(color: Colors.red),)));
                        },
                        child: Text('Request Visit', style: TextStyle(color: Theme.of(context).primaryColor),)
                    ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).hintColor,
                          foregroundColor: Theme.of(context).primaryColor
                      ),
                      onPressed: () {
                        //Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FetchAdminContactWidget()));
                        appState.currentState=0;
                      }, child: Text('Contact Now',style: TextStyle(color: Theme.of(context).primaryColor),))),
            ],
          ),
          Center(
            child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).hintColor
                ),
                onPressed: (){},
                child: Text(
                  'Book Now',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor
                  ),
                )
            ),
          )
        ],
      ),
    ));
  }
}
