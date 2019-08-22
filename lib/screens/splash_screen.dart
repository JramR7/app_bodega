import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _getThingsOnStartup().then((value) {
      Navigator.of(context).pushReplacementNamed('/welcome');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'images/starting.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/logo.png',
                  scale: 3.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 3));
  }
}
