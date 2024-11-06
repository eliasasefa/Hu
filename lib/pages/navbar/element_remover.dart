import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ElementRemover extends StatelessWidget {
  const ElementRemover({super.key});

  Future<void> evaluateJavaScriptToHideElements(
      InAppWebViewController controller) async {
    await controller.evaluateJavascript(
      source: "document.querySelector('header').style.display = 'none';",
    );
    await controller.evaluateJavascript(
      source: "document.querySelector('footer').style.display = 'none';",
    );
    await controller.evaluateJavascript(
      source: "document.getElementById('main-navbar').style.display = 'none';",
    );
    await controller.evaluateJavascript(
      source: "document.getElementById('footer-copy').style.display = 'none';",
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
