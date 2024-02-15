import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
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
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.postBlog(appState.token, data, url);
    if (res.isNotEmpty) {
      //print(res);
      Navigator.pop(context);
      if (res['success'] == true) {
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
      } else {
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.red, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
        child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColorLight,
                title: const Text('Post New Blog'),
                centerTitle: true,
              ),
              backgroundColor: Theme.of(context).primaryColorLight,
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
                              backgroundColor: Theme.of(context).primaryColor,
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
        )
    );
  }
}
