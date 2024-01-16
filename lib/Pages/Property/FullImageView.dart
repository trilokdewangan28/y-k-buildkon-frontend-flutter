
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

class FullImageView extends StatelessWidget {
  const FullImageView({Key? key, required this.imageUrl, required this.asFinder}) : super(key: key);

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
     final res = await StaticMethod.deletePropertyImage(data,url);
     if(res.isNotEmpty){
       Navigator.pop(context);
       if(res['success']==true){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.green),)));
         appState.activeWidget='PropertyListWidget';
         Navigator.pop(context);
       }else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.red),)));
       }
     }

   }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    //print(imageUrl);
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
