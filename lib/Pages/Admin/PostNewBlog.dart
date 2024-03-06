import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

import '../../services/ThemeService/theme.dart';
class PostNewBlog extends StatefulWidget {
  const PostNewBlog({super.key});

  @override
  State<PostNewBlog> createState() => _PostNewBlogState();
}

class _PostNewBlogState extends State<PostNewBlog> {
  final _formKey = GlobalKey<FormState>();
  final _blogTitleController = TextEditingController();
  final _blogSubTitleController = TextEditingController();
  final _blogUrlController = TextEditingController();

  final FocusNode _blogTitleFocusNode = FocusNode();
  final FocusNode _blogSubTitleFocusNode = FocusNode();
  final FocusNode _blogUrlFocusNode = FocusNode();
  
  _submitData(data,appState,context)async{
    var url = Uri.parse(ApiLinks.postBlog);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>  Center(
        child:StaticMethod.progressIndicator()
      ),
    );
    final res = await StaticMethod.postBlog(appState.token, data, url);
    if (res.isNotEmpty) {
      //print(res);
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
        child: Scaffold(
          backgroundColor:context.theme.backgroundColor,
            appBar: _appBar('Post New Blog'),
            body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child:Form(
                  key:_formKey,
                  child:Column(
                    children: [
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: _blogTitleController,
                        focusNode: _blogTitleFocusNode,
                        decoration: InputDecoration(
                            labelText: 'Blog Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'please enter valid title';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: _blogSubTitleController,
                        focusNode: _blogSubTitleFocusNode,
                        decoration: InputDecoration(
                            labelText: 'Blog subtitle',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'please enter valid subtitle';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: TextFormField(
                            controller: _blogUrlController,
                            focusNode: _blogUrlFocusNode,
                            decoration: InputDecoration(
                                labelText: 'Blog Url',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return 'please enter valid url';
                              }
                              return null;
                            },
                          ),),
                          TextButton(
                              onPressed: (){
                                StaticMethod.openMap('googlechrome://www.google.com');
                              },
                              child: const Text('Open Browser')
                          )
                        ],
                      ),

                      const SizedBox(height: 20,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: bluishClr,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                          onPressed: (){
                            var data = {
                              "blog_title":_blogTitleController.text,
                              "blog_subtitle":_blogSubTitleController.text,
                              "blog_url":_blogUrlController.text
                            };

                            if (_formKey.currentState!.validate()) {
                              _submitData(data, appState, context);
                            }
                          },
                          child: Text(
                            'Post Now',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColorLight
                            ),
                          )
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
  _appBar(appBarContent){
    return AppBar(
      iconTheme: IconThemeData(
        color: Get.isDarkMode ?  Colors.white70 :Colors.black,
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
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/ic_launcher.png',
                height: 100,
              )
          ),
        ),
      ],
      backgroundColor: Get.isDarkMode
          ? Colors.black45 : Colors.white,
    );
  }
}
