
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';


class ImagePickerPage extends StatefulWidget {
  final Map<String,dynamic> userDetails;
  final String forWhich;


  ImagePickerPage({Key? key, required this.userDetails, required this.forWhich,}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  bool _mounted = false;
  //------------------------------------------------------PICK IMAGE FROM GALARY
  Future _pickImageFromGallery(appState) async {
    //print('pick image from galary method called');
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(_mounted){
      setState(() {
        if (pickedImage != null) {
          appState.imageFile = File(pickedImage.path);
        } else {
          //print('No image selected.');
        }
      });
    }
  }

//-----------------------------------------------------CAPTURE IMAGE FROM CAMERA
  Future _captureImageFromCamera(appState) async {
    //print('capture image from camera method called');
    final picker = ImagePicker();
    final capturedImage = await picker.pickImage(source: ImageSource.camera);

    if(_mounted){
      setState(() {
        if (capturedImage != null) {
          appState.imageFile = File(capturedImage.path);
        } else {
          //print('No image captured.');
        }
      });
    }
  }

//------------------------------------------------------------UPLOAD PROFILE PIC
  Future<Map<String, dynamic>> uploadImage(data, Uri url, forWhich, appState) async {
    //print('upload profile pic method called');
    //print(url);
    //print(data['email']);
    //print(data['imageFile']);
    //print(url);
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    // Add token to the headers
    request.headers['Authorization'] = 'Bearer ${appState.token}';
    if(forWhich == "adminProfilePic"){
      request.fields['ad_id'] = data['ad_id'].toString();
    }else if(forWhich == "customerProfilePic"){
      request.fields['c_id'] = data['c_id'].toString();
    }else if(forWhich == "propertyImage"){
      request.fields['p_id'] = data['p_id'].toString();
    }else if(forWhich == "offerImage"){
      request.fields['p_id'] = data['p_id'].toString();
    }
    var mimeType = lookupMimeType(data['imageFile'].path);
    var fileExtension = mimeType!.split('/').last;

    var pic = await http.MultipartFile.fromPath(
      forWhich,
      data['imageFile'].path,
      contentType: MediaType('image', fileExtension),
    );
    request.files.add(pic);
    try {
      var res = await request.send();
      if (res.statusCode == 200) {
        //print('image uploaded successful inside the upload function');
        return jsonDecode(await res.stream.bytesToString());
      } else {
        return jsonDecode(await res.stream.bytesToString());
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while image uploading',
        'error': '$e',
      };
    }
  }

  //----------------------------------------------------------------BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return SafeArea(child: PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        appState.imageFile = null;
        //Navigator.pop(context);
      },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Image Picker'),
          ),
          body: Container(
            color: Theme.of(context).primaryColorLight,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20,),
                  appState.imageFile != null
                      ? Image.file(
                    appState.imageFile!,
                    height: 200,
                  )
                      : Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Icon(Icons.image_not_supported_outlined,size: 50,),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  //--------------------------------------------FROM GALARY BUTTON
                  // ===========================buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          //--------------------------------------------FROM GALARY BUTTON
                          IconButton(onPressed: ()async{
                            _mounted=true;
                            await _pickImageFromGallery(appState);
                          },
                              icon: Icon(Icons.photo, color: Theme.of(context).primaryColor, size: 50,)
                          ),
                          const Text('Galary')
                        ],
                      ),
                      const SizedBox(width: 100),
                      Column(
                        children: [
                          //--------------------------------------------FROM CAMERA BUTTON
                          IconButton(onPressed: ()async{
                            _mounted=true;
                            await _captureImageFromCamera(appState);
                          },
                              icon: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor, size: 50,)
                          ),
                          const Text('Camera')
                        ],
                      )
                    ],
                  ),
                  //-----------------------------------------DELETE PROFILE BUTTON
                  // widget.forWhich=='profilePic' && appState.userDetail['result']['profilePic'] != null
                  //     ? ElevatedButton(
                  //         onPressed: () async {
                  //           Uri url;
                  //           if(widget.forWhich=='profilePic'){
                  //             if (appState.userType == 'guest') {
                  //               url = Uri.parse(ApiLinks.deleteGuestProfilePicApi);
                  //             } else{
                  //               url = Uri.parse(ApiLinks.deleteOwnerProfilePicApi);
                  //             }
                  //           }else{
                  //             url=Uri.parse(ApiLinks.deleteOwnerHostlePicApi);
                  //           }
                  //
                  //           var data = {
                  //             "email": widget.userData['email'],
                  //             "profilePic": appState.userDetail['result']['profilePic']
                  //           };
                  //           showDialog(
                  //             context: context,
                  //             barrierDismissible: false,
                  //             builder: (dialogContext) => const Center(
                  //               child: CircularProgressIndicator(),
                  //             ),
                  //           );
                  //           final response = await StaticMethod.removeUploadedImage(data,url);
                  //           Navigator.pop(context);
                  //           if(response.isNotEmpty){
                  //             StaticMethod.showDialogMessage(context, response, appState, 'Deletion Response');
                  //           }
                  //           },
                  //         child: const Text('remove profile pic'),
                  //       )
                  //     : Container(),
                ],
              ),
            ),
          ),
          //-------------------------------------------------FLOATING ACTION BTN
          floatingActionButton: appState.imageFile != null
              ? FloatingActionButton(
                  onPressed: () async {
                    //print('floating button acion called');
                      var url;
                      if(widget.forWhich=='customerProfilePic'){
                        url = Uri.parse(ApiLinks.uploadCustomerProfilePic);
                      }else if(widget.forWhich=='offerImage'){
                        url = Uri.parse(ApiLinks.uploadOffer);
                      }else if(widget.forWhich=='propertyImage'){
                        url = Uri.parse(ApiLinks.uploadPropertyImage);
                      }else if(widget.forWhich=='adminProfilePic'){
                        url = Uri.parse(ApiLinks.uploadAdminProfilePic);
                      }
                      var data;
                      if(widget.forWhich=="adminProfilePic"){
                        data = {
                          "ad_id":widget.userDetails['admin_id'],
                          "imageFile":appState.imageFile!
                        };
                      }else if(widget.forWhich=="customerProfilePic"){
                         data={
                          "c_id":widget.userDetails['customer_id'],
                          "imageFile":appState.imageFile!
                        };
                      }else if(widget.forWhich=='propertyImage'){
                        data={
                          "p_id":widget.userDetails['property_id'],
                          "imageFile":appState.imageFile!
                        };
                      }else if(widget.forWhich=='offerImage'){
                        data={
                          "p_id":widget.userDetails['property_id'],
                          "imageFile":appState.imageFile!
                        };
                      }
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      final response = await uploadImage(data, url, widget.forWhich, appState);
                      //print('inside the floating action');
                      //print(response);
                      if(response.isNotEmpty){
                        Navigator.pop(context);
                        if(response['success']==true){
                          StaticMethod.showDialogBar(response['message'], Colors.green);
                          if(appState.activeWidget=="PropertyDetailPage"){
                            appState.activeWidget="PropertyListPage";
                            Navigator.pop(context);
                          }else {
                            Navigator.pop(context);
                          }
                        }else{
                          StaticMethod.showDialogBar(response['message'], Colors.red);
                        }
                      }
                  },
                  child: const Icon(Icons.check),
                )
              : null,
        )));
  }
}
