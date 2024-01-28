import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Property/SinglePropertyListWidget.dart';
import 'package:real_state/config/ApiLinks.dart';
class OfferListPage extends StatefulWidget {
  const OfferListPage({Key? key}) : super(key: key);

  @override
  State<OfferListPage> createState() => _OfferListPageState();
}

class _OfferListPageState extends State<OfferListPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return PopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('offer list'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: appState.offerList.length,
                itemBuilder: (context,index){
                  final offer = appState.offerList[index];
                  final imageUrl = '${ApiLinks.accessOfferImage}/${offer['image_url']}';
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SinglePropertyListWidget(property_id: offer['property_id'],)));
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // offer image container
                            Container(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    //height: 200,
                                    fit: BoxFit.fitHeight,
                                  )
                              ),
                            ),

                            // offer detail container
                            Container(
                              child: Text(offer['about1']),
                            ),
                            Container(
                              child: Text(offer['about2']),
                            ),
                            Container(
                              child: Text(offer['about3']),
                            )
                          ],
                        )
                    ),
                  );
                }
            ),
          )
        )
    );
  }
}
