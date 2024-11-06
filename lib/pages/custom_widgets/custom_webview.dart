import 'package:flutter/material.dart';
import 'package:mywebapp/pages/custom_widgets/custom_widget.dart';

class CustomWebView extends StatelessWidget {
  final String url;

  const CustomWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Image(
              image: AssetImage('assets/images/hu1-logo.png'),
            ),
            onPressed: () {},
          ),
          const SizedBox(
            width: 15,
          )
        ],
        foregroundColor: Colors.white,
        toolbarHeight: 40.0,
        titleTextStyle: const TextStyle(
          fontFamily: 'verdana',
          fontSize: 16.0,
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text('Haramaya University'),
      ),
      body: WebViewPage(url: url),
    );
  }
}
