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
  InAppWebViewController? controller;

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
              javaScriptEnabled: true,
              cacheEnabled: true,
            ),
          ),
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          onWebViewCreated: (InAppWebViewController controller) {
            this.controller = controller;
          },
          onLoadStart: (InAppWebViewController controller, Uri? url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) async {
            try {
              await remover.evaluateJavaScriptToHideElements(controller);
            } catch (e) {
              print('Error hiding elements: $e');
            }
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onLoadError: (InAppWebViewController controller, Uri? url, int code,
              String message) {
            print("Error loading page: $code, $message");
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (_hasError)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error loading page.\nPlease check your internet connection.',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _hasError = false;
                    });
                    controller?.reload();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
