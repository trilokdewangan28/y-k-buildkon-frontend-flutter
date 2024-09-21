
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';

class FullImageView extends StatelessWidget {
  const FullImageView({super.key, required this.imageUrl, required this.asFinder});

  final imageUrl;
  final bool asFinder;


   //----------------------------------------------------------------------------SEND OTP METHODS

   _deletePropertyImage(BuildContext context, appState, imageUrl)async{
     //print('send otp called');
     var data = {
       "propertyImage":imageUrl,
     };
     var url = Uri.parse(ApiLinks.deletePropertyImage);
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (dialogContext) => const Center(
         child: CircularProgressIndicator(),
       ),
     );
     final res = await StaticMethod.deletePropertyImage(appState.token, data,url);
     if(res.isNotEmpty){
       Navigator.pop(context);
       if(res['success']==true){
         StaticMethod.showDialogBar(res['message'], Colors.green);
         appState.activeWidget='PropertyListPage';
         Navigator.pop(context);
       }else{
         StaticMethod.showDialogBar(res['message'], Colors.red);
       }
     }

   }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
        child: SafeArea(child:
        Scaffold(
          appBar: AppBar(
            title: const Text('Full Image View'),
            actions: [
              appState.userType=='admin'
                  ? IconButton(
                  onPressed: (){
                    _deletePropertyImage(context, appState, imageUrl);
                  },
                  icon: const Icon(Icons.delete,color: Colors.red,)
              )
                  : Container()
            ],
          ),
      body:PhotoView(
          imageProvider: NetworkImage('${ApiLinks.accessPropertyImages}/$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.0,
        ),
    )));
  }
}
