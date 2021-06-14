//import 'dart:convert';
import 'dart:async';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pegadaian/login.dart';
//import 'package:pegadaian/verifikasiktp.dart';
//import 'package:flutter/services.dart';
//import 'package:pegadaian/verifikasiktp.dart';
//import 'package:uni_links/uni_links.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  //final String data;
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 1;

  @override
  void initState() {
    super.initState();
    //initUniLinks().then((d) {
    //setState(() {});
    //});
    _loadWidget();
    //initUniLinks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    //Navigator.pushReplacement(context,
    //MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/logos.png",
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
