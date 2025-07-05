import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ElementRemover {
  Future<void> evaluateJavaScriptToHideElements(
      InAppWebViewController controller) async {
    try {
      // Hide header if it exists
      await controller.evaluateJavascript(
        source: """
          try {
            const header = document.querySelector('header');
            if (header) header.style.display = 'none';
          } catch(e) {
            console.log('Header not found');
          }
        """,
      );

      // Hide footer if it exists
      await controller.evaluateJavascript(
        source: """
          try {
            const footer = document.querySelector('footer');
            if (footer) footer.style.display = 'none';
          } catch(e) {
            console.log('Footer not found');
          }
        """,
      );

      // Hide main navbar if it exists
      await controller.evaluateJavascript(
        source: """
          try {
            const navbar = document.getElementById('main-navbar');
            if (navbar) navbar.style.display = 'none';
          } catch(e) {
            console.log('Main navbar not found');
          }
        """,
      );

      // Hide footer copy if it exists
      await controller.evaluateJavascript(
        source: """
          try {
            const footerCopy = document.getElementById('footer-copy');
            if (footerCopy) footerCopy.style.display = 'none';
          } catch(e) {
            console.log('Footer copy not found');
          }
        """,
      );
    } catch (e) {
      print('Error evaluating JavaScript: $e');
    }
  }
}
