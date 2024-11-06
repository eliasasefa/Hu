import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mywebapp/pages/navbar/element_remover.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final InAppWebViewController controller;

  bool _isLoading = true;
  bool _hasError = false;
  ElementRemover remover = ElementRemover();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
            ),
          ),
          initialUrlRequest: URLRequest(
            iosAllowsCellularAccess: true,
            url: Uri.parse(widget.url),
          ),
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
          onLoadStart: (InAppWebViewController controller, Uri? url) {
            setState(() {
              _isLoading = true;
            });
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) {
            remover.evaluateJavaScriptToHideElements(controller);
            setState(() {
              _isLoading = false;
            });
          },
          onLoadError: (controller, url, code, message) {
            print("Error loading page: $code, $message");
            setState(() {
              _hasError = true;
            });
          },
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
        if (_hasError)
          Center(
            child: Text(
              'Error loading page. \nPlease check your internet connection.',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}

