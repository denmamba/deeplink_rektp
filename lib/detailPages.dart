import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_deeplink/main.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:test_deeplink/transitions/enter_exit_route.dart';

const _url = 'rektp://read?type=0';

class DetailPages extends StatefulWidget {
  final String? data;
  final String? title;
  final Map? rowSiswa;

  // receive data from the FirstScreen as a parameter
  DetailPages({
    Key? key,
    required this.data,
    this.title,
    this.rowSiswa,
  }) : super(key: key);

  @override
  _DetailPagesState createState() => _DetailPagesState();
}

class _DetailPagesState extends State<DetailPages> {
  late Timer _ulangWaktu;
  late int _mulai = 3;

  void _connectRektp() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  //module navigasi ke home
  void navigasiback() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(kodenik: '0')));
    _connectRektp();
  }

  @override
  void dispose() {
    _ulangWaktu.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //setting otomatis back to home/scan ktp-el
    const oneDetik = const Duration(seconds: 1);
    _ulangWaktu = new Timer.periodic(
      oneDetik,
      (Timer timer) {
        if (_mulai == 0) {
          setState(() {
            _ulangWaktu.cancel();
            navigasiback();
          });
        } else {
          setState(() {
            _mulai--;
            _ulangWaktu.cancel();
          });
        }
      },
    );

    return new WillPopScope(
        onWillPop: () async => true,
        child: new Scaffold(
          appBar: AppBar(
              title: Text('Status'),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MyHomePage(kodenik: '0')));
                },
              )),
          body: new SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text(
                    "$_mulai",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                  SizedBox(height: 200),
                  Center(
                      child: Text(
                    "Halo ${widget.data.toString()} ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  )),
                  Center(
                      child: Text(
                    'Terimakasih sudah menunggu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                  SizedBox(height: 20),
                  Center(
                      child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    color: Colors.green.shade700,
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Container(
                            height: 60,
                            width: 100,
                            padding: EdgeInsets.all(0.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'IN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 25),
                      ],
                    ),
                  )),
                ],
              )),
        ));
  }
}
