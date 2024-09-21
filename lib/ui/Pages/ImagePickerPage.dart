import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';

class ImagePickerPage extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  final String forWhich;

  const ImagePickerPage({
    super.key,
    required this.userDetails,
    required this.forWhich,
  });

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  bool _mounted = false;

  Future _pickImageFromGallery(appState) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (_mounted) {
      setState(() {
        if (pickedImage != null) {
          appState.imageFile = File(pickedImage.path);
        }
      });
    }
  }

  Future _captureImageFromCamera(appState) async {
    final picker = ImagePicker();
    final capturedImage = await picker.pickImage(source: ImageSource.camera);

    if (_mounted) {
      setState(() {
        if (capturedImage != null) {
          appState.imageFile = File(capturedImage.path);
        }
      });
    }
  }

  Future<Map<String, dynamic>> uploadImage(data, Uri url, forWhich, appState) async {
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    request.headers['Authorization'] = 'Bearer ${appState.token}';

    if (forWhich == "adminProfilePic") {
      request.fields['ad_id'] = data['ad_id'].toString();
    } else if (forWhich == "customerProfilePic") {
      request.fields['c_id'] = data['c_id'].toString();
    } else if (forWhich == "propertyImage") {
      request.fields['p_id'] = data['p_id'].toString();
    } else if (forWhich == "offerImage") {
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

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    double fontSizeScaleFactor = MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        appState.imageFile = null;
      },
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: _appBar('Image Picker'),
        body: SizedBox(
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
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            _mounted = true;
                            await _pickImageFromGallery(appState);
                          },
                          icon: const Icon(
                            Icons.photo,
                            color: bluishClr,
                            size: 50,
                          ),
                        ),
                        const Text('Gallery')
                      ],
                    ),
                    const SizedBox(width: 100),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            _mounted = true;
                            await _captureImageFromCamera(appState);
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: bluishClr,
                            size: 50,
                          ),
                        ),
                        const Text('Camera')
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: appState.imageFile != null
            ? FloatingActionButton(
          onPressed: () async {
            Uri url;
            if (widget.forWhich == 'customerProfilePic') {
              url = Uri.parse(ApiLinks.uploadCustomerProfilePic);
            } else if (widget.forWhich == 'offerImage') {
              url = Uri.parse(ApiLinks.uploadOffer);
            } else if (widget.forWhich == 'propertyImage') {
              url = Uri.parse(ApiLinks.uploadPropertyImage);
            } else if (widget.forWhich == 'adminProfilePic') {
              url = Uri.parse(ApiLinks.uploadAdminProfilePic);
            } else {
              // Handle the case where widget.forWhich does not match any known value
              throw Exception('Unknown value for widget.forWhich: ${widget.forWhich}');
            }

            Map<String, dynamic> data;
            if (widget.forWhich == "adminProfilePic") {
              data = {
                "ad_id": widget.userDetails['admin_id'],
                "imageFile": appState.imageFile!,
              };
            } else if (widget.forWhich == "customerProfilePic") {
              data = {
                "c_id": widget.userDetails['customer_id'],
                "imageFile": appState.imageFile!,
              };
            } else if (widget.forWhich == 'propertyImage') {
              data = {
                "p_id": widget.userDetails['property_id'],
                "imageFile": appState.imageFile!,
              };
            } else if (widget.forWhich == 'offerImage') {
              data = {
                "p_id": widget.userDetails['property_id'],
                "imageFile": appState.imageFile!,
              };
            } else {
              // Handle the case where widget.forWhich does not match any known value
              throw Exception('Unknown value for widget.forWhich: ${widget.forWhich}');
            }

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            final response = await uploadImage(data, url, widget.forWhich, appState);
            if (response.isNotEmpty) {
              Navigator.pop(context);
              if (response['success'] == true) {
                StaticMethod.showDialogBar(response['message'], Colors.green);
                if (appState.activeWidget == "PropertyDetailPage") {
                  appState.activeWidget = "PropertyListPage";
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              } else {
                StaticMethod.showDialogBar(response['message'], Colors.red);
              }
            }
          },
          backgroundColor: bluishClr,
          child: const Icon(Icons.check),
        )
            : null,
      ),
    );
  }

  AppBar _appBar(String appBarContent) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Get.isDarkMode ? Colors.white70 : Colors.black,
        size: MyConst.deviceHeight(context) * 0.030,
      ),
      toolbarHeight: MyConst.deviceHeight(context) * 0.060,
      titleSpacing: MyConst.deviceHeight(context) * 0.02,
      elevation: 0.0,
      title: Text(
        appBarContent,
        style: appbartitlestyle,
        softWrap: true,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/images/ic_launcher.png',
              height: 100,
            ),
          ),
        ),
      ],
      backgroundColor: Get.isDarkMode ? Colors.black45 : Colors.white,
    );
  }
}
