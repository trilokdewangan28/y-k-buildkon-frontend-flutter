
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

import '../../services/ThemeService/theme.dart';


class AddOfferPage extends StatefulWidget {
  final int p_id;
  final String forWhich;


  AddOfferPage({Key? key, required this.p_id, required this.forWhich,}) : super(key: key);

  @override
  State<AddOfferPage> createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  bool _mounted = false;
  final _formKey = GlobalKey<FormState>();
  final _aboutOneController = TextEditingController();
  final FocusNode _aboutOneFocusNode = FocusNode();

  final _aboutTwoController = TextEditingController();
  final FocusNode _aboutTwoFocusNode = FocusNode();

  final _aboutThreeController = TextEditingController();
  final FocusNode _aboutThreeFocusNode = FocusNode();
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
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    request.headers['Authorization'] = 'Bearer ${data['token']}';
    if(forWhich == "adminProfilePic"){
      request.fields['ad_id'] = data['ad_id'].toString();
    }else if(forWhich == "customerProfilePic"){
      request.fields['c_id'] = data['c_id'].toString();
    }else if(forWhich == "propertyImage"){
      request.fields['p_id'] = data['p_id'].toString();
    }else if(forWhich == "offerImage"){
      request.fields['p_id'] = data['p_id'].toString();
      request.fields['of_text1'] = data['of_text1'].toString();
      request.fields['of_text2'] = data['of_text2'].toString();
      request.fields['of_text3'] = data['of_text3'].toString();
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
      var responseBody = await res.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      if (res.statusCode == 200) {
        //print('image uploaded successful inside the upload function');
        return jsonResponse;
        // return {
        //   'success': true,
        //   'message': 'image uploaded successfully',
        // };
      } else {
        return jsonResponse;
      }
    } catch (e) {
      //print(e);
      return {
        'success': false,
        'message': 'An error occurred while image uploading $e',
        'error': '$e',
      };
    }
  }

//------------------------------------------------------------SUBMIT THE DATA
 _submitData(appState, data, url) async {
   //print('submit data method called');
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
       print(response);
       StaticMethod.showDialogBar(response['message'], Colors.green);
       if(appState.activeWidget=="PropertyDetailPage"){
         appState.activeWidget="PropertyListPage";
         Navigator.pop(context);
       }else {
         Navigator.pop(context);
       }
     }else{
       print(response);
       StaticMethod.showDialogBar(response['message'], Colors.red);
     }
   }
 }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  //----------------------------------------------------------------BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          appState.imageFile = null;
          appState.activeWidget = "PropertyListPage";
        },
        child: Scaffold(
          backgroundColor: context.theme.backgroundColor,
          appBar: _appBar('Add New Offer'),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
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
                              icon: Icon(Icons.photo, color:bluishClr, size: 50,)
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
                              icon: Icon(Icons.camera_alt, color: bluishClr, size: 50,)
                          ),
                          const Text('Camera')
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  //============================form container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15,),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //===========================ABOUT OFFER TEXTFIELD 1
                            _textField(
                                controller: _aboutOneController, 
                                focusNode: _aboutOneFocusNode, 
                                label: 'About 1', 
                                inputtype: TextInputType.text
                            ),
                            const SizedBox(height: 20,),

                            //===========================ABOUT OFFER TEXTFIELD 2
                            _textField(
                                controller: _aboutTwoController,
                                focusNode: _aboutTwoFocusNode,
                                label: 'About 2',
                                inputtype: TextInputType.text
                            ),
                            const SizedBox(height: 20,),

                            //===========================ABOUT OFFER TEXTFIELD 3
                            _textField(
                                controller: _aboutThreeController,
                                focusNode: _aboutThreeFocusNode,
                                label: 'About 3',
                                inputtype: TextInputType.text
                            ),
                            const SizedBox(height: 20,),

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: bluishClr,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                                onPressed: (){
                                  if (_formKey.currentState!.validate()) {
                                    var url = Uri.parse(ApiLinks.uploadOffer);
                                    var data = {
                                      "token":appState.token,
                                      "p_id":widget.p_id,
                                      "of_text1":_aboutOneController.text,
                                      "of_text2":_aboutTwoController.text,
                                      "of_text3":_aboutThreeController.text,
                                      "imageFile":appState.imageFile!
                                    };
                                    _submitData(appState,data, url);
                                  }
                                },
                                child: Text('Submit', style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.w600
                                ),)
                            )
                          ],
                        )
                    ),
                  )

                ],
              ),
            ),
          ),

        ));
  }
  _appBar(appBarContent){
    return AppBar(
      foregroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color:Get.isDarkMode?Colors.white70:Colors.black,
        size: MyConst.deviceHeight(context)*0.030,
      ),
      toolbarHeight: MyConst.deviceHeight(context)*0.060,
      titleSpacing: MyConst.deviceHeight(context)*0.02,
      elevation: 0.0,
      title:Text(
        appBarContent,
        style: appbartitlestyle,
        softWrap: true,
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/ic_launcher.png'
            ),
          ),
        )
      ],
      backgroundColor: context.theme.backgroundColor,
    );
  }
  _textField(
  {
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String? label,
    required TextInputType? inputtype,
    validator
}
      ){
    return TextFormField(
        focusNode: focusNode,
        controller: controller,
        maxLines: 3,
        keyboardType: inputtype,
        decoration:  InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Get.isDarkMode?Colors.white: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: bluishClr
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            )),
        validator:validator);
  }
}
