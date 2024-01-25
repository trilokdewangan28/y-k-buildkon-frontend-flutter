import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
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
          body: Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: appState.offerList.length,
                      itemBuilder: (context,index){
                        //final offer = appState.offerList[index];
                        return Column(
                          children: [
                            // offer image container
                            Container(),

                            // offer detail container
                            Container()
                          ],
                        );
                      }
                  ),
                ],
              ),
            ),
          )
        )
    );
  }
}
