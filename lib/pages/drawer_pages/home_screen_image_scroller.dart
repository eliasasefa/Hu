import 'package:flutter/material.dart';

class AutoImageChangerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/images/hu1.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
