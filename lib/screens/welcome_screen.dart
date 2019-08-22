import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.95,
              child: Image.asset(
                'images/lines.png',
                colorBlendMode: BlendMode.multiply,
                color: Colors.white,
                width: screenWidth,
                height: screenHeight,
                fit: BoxFit.fill,
              ),
            ),
            ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 120.0, bottom: 95.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: 0.9,
                      child: Image.asset(
                        'images/logo.png',
                        scale: 3.8,
                      ),
                    ),
                  ),
                ),
                _menuButton('Ver pedidos', _goToSeeOrders()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _menuButton(String text, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 280.0,
        height: 68.0,
        child: RaisedButton(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 27.0,
                fontWeight: FontWeight.bold),
          ),
          color: Color.fromRGBO(231, 190, 66, 0.9),
          highlightColor: Color.fromRGBO(29, 119, 58, 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Function _goToSeeOrders() {
    return () {
      Navigator.pushNamed(context, '/seeOrders');
    };
  }
}
