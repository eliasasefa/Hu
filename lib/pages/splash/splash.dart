import 'package:flutter/material.dart';
import 'package:hu/pages/navbar/main_home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _GoToHomePage();
    super.initState();
  }

  _GoToHomePage() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHome(
            toggleTheme: () {},
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/hu1-logo.png'),
              width: 100,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Haramaya University',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
