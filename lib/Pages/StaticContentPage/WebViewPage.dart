import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController _controller;
  bool goBack = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          _controller.goBack();
          return false;
        }else{
          return true;
        }
      },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter WebView'),
          ),
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri(widget.url)
                ),
                onWebViewCreated: (InAppWebViewController controller){
                  _controller = controller;
                },
                onProgressChanged: (InAppWebViewController controller, int progress){
                  setState(() {
                    _progress = progress/100;
                  });
                },
              ),
              _progress<1
                  ? LinearProgressIndicator(
                value: _progress,
              ) : Container()
            ],
          ),
        )
    );
  }
}
