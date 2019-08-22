import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/see_orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/welcome': (BuildContext context) => WelcomeScreen(),
        '/seeOrders': (BuildContext context) => SeeOrdersScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
