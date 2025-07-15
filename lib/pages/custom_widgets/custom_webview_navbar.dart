import 'package:flutter/material.dart';
import 'package:hu/pages/custom_widgets/custom_widget.dart';

class CustomWebViewNavbar extends StatelessWidget {
  final String url;

  const CustomWebViewNavbar({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewPage(url: url),
    );
  }
}
