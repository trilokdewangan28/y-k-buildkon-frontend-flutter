import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Admin/PostNewBlog.dart';
import 'package:real_state/Pages/Error/SpacificErrorPage.dart';
import 'package:real_state/Pages/StaticContentPage/WebViewPage.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  bool postBlog = false;
  List<dynamic> blogList = [];
  bool _mounted = false;
  
  //==============================PAGINATION VARIABLE
  int page = 1;
  final int limit = 10;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  //==========================================first load method
  _fetchBlog(appState)async{
    if(_mounted){
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    Map<String,dynamic> paginationOptions = {
      "page":page,
      "limit":limit
    };
    var url = Uri.parse(ApiLinks.fetchBlog);
    final res = await StaticMethod.fetchBlog(appState, paginationOptions, url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        blogList = res['result'];
        if(_mounted){
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      } else {
        //print(res['error']);
        appState.error = res['error'];
        appState.errorString=res['message'];
        appState.fromWidget=appState.activeWidget;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
          _mounted=true;
          _fetchBlog(appState);
        });
      }
    }
  }

  //==========================================load modre method
  void _loadMore(appState) async {

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300 && _mounted
    ) {
      if(_mounted){
        setState(() {
          _isLoadMoreRunning = true; // Display a progress indicator at the bottom
        });
      }

      page += 1; // Increase _page by 1
      Map<String,dynamic> paginationOptions = {
        "page":page,
        "limit":limit
      };
      var url = Uri.parse(ApiLinks.fetchBlog);
      final res = await StaticMethod.fetchBlog(appState, paginationOptions, url);
      if (res.isNotEmpty) {
        if (res['success'] == true) {
          if(res['result'].length>0){
            //print('succes is true and result is ${res['result']}');
            if(_mounted){
              setState(() {
                blogList.addAll(res['result']);
                _isFirstLoadRunning = false;
              });
            }
          }else{
            if(_mounted){
              setState(() {
                _hasNextPage = false;
              });
            }
            Fluttertoast.showToast(
              msg: 'No More Content Available',
              toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
              gravity: ToastGravity.TOP, // Toast position
              backgroundColor: Colors.black, // Background color of the toast
              textColor: Colors.green, // Text color of the toast message
              fontSize: 16.0, // Font size of the toast message
            );
          }
        } else {
          //print(res['error']);
          appState.error = res['error'];
          appState.errorString=res['message'];
          appState.fromWidget=appState.activeWidget;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SpacificErrorPage())).then((_) {
            _mounted=true;
            _hasNextPage = true;
            _fetchBlog(appState);
          });
        }
      }
      if (_mounted) {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
    }
  }

  late ScrollController _controller;
  @override
  void initState() {
    ///print('initstate methond called');
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _fetchBlog(appState);
    _mounted = true;
    _controller = ScrollController()..addListener(() => _loadMore(appState));
    //print('initstate called');
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
        child: RefreshIndicator(
          child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Blog list'),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  centerTitle: true,
                ),
                body: _isFirstLoadRunning==true
                    ? Container(child: const Center(child:CircularProgressIndicator(),))
                    : blogList.isNotEmpty
                    ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight
                  ),
                  child: Container(
                      child: ListView.builder(
                          itemCount: blogList.length,
                          itemBuilder: (context,index){
                            final blog = blogList[index];
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewPage(url: blog['blog_url'])));
                              },
                              child: ListTile(
                                title: Text('${blog['blog_title']}'),
                                subtitle: Text('${blog['blog_subtitle']}'),
                              ),
                            );
                          }
                      )
                  ),
                )
                    : Container(child: const Center(child: Text('empty blog'),),),

                floatingActionButton: appState.userType=='admin' ? CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 30,
                  child: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const PostNewBlog()));
                      },
                      icon: Icon(Icons.add,color: Theme.of(context).primaryColorLight,)
                  ),
                ) : null
            ),
          ),
          onRefresh: ()async{
            // setState(() {
            _hasNextPage=true;
            page=1;
            _isFirstLoadRunning=false;
            _isLoadMoreRunning=false;
            _fetchBlog(appState);
          },
        )
    );
  }
}
