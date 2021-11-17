// @dart=2.9
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:woman_safety/Utilities.dart';
import 'package:woman_safety/model/User.dart';
import 'package:woman_safety/view/HomePage.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreen_State();
  }
}

class SplashScreen_State extends State<SplashScreen> {
  bool status = false;
  BuildContext contextt;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      getuserExistence();
    });
  }

  getuserExistence() async {
    var user;
    try {
      user = await OurDatabase(table: User().table).databaseExists();
    } catch (e) {
      print(e);
    }

    if (user) {
      Navigator.pushReplacement(contextt,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    } else {
      Navigator.pushReplacement(contextt,
          MaterialPageRoute(builder: (BuildContext context) => Register()));
    }
  }

  @override
  Widget build(BuildContext context) {
    contextt = context;
     return Scaffold(body: Center(child: Lottie.asset("assets/womens.json")));
  }
}
