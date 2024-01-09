
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';

class FullImageView extends StatelessWidget {
   FullImageView({Key? key, required this.imageUrl, required this.asFinder}) : super(key: key);

  final imageUrl;
  bool asFinder;


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    print(imageUrl);
    return WillPopScope(
        onWillPop: ()async{
          Navigator.pop(context);
          return false;
        },
        child: SafeArea(child:
        Scaffold(
          appBar: AppBar(
            title: const Text('Full Image View'),
            actions: [
            ],
          ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage('${ApiLinks.accessPropertyImages}/${imageUrl}?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.0,
        ),
      ),
    )));
  }
}
