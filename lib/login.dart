import 'dart:convert';
import "dart:async";
import 'package:flutter/services.dart';
//import 'package:pegadaian/splash.dart';
import 'package:flutter/material.dart';
import 'package:pegadaian/validation_ktp.dart';
//import 'package:pegadaian/verifikasiktp.txt';
import 'package:uni_links/uni_links.dart';
import 'utils.dart' as util;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
//import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
//import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.data}) : super(key: key);
  final String title;
  final String data;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validation {
  final formKey = GlobalKey<FormState>();
  TextEditingController _txtUser = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  //. flag loading
  bool _isLoading = false;
  bool _checkSession = true;
  int _defaultIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            // Code to execute.
          },
        ),
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red.shade700,
        content: new Text(value)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: _checkSession == true
            ? //SplashScreen()
            Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.white, Colors.white],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/logos.png",
                        width: 200,
                      ),
                      SizedBox(height: 10),
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Wait a moment.."),
                    ],
                  ),
                ))
            : DoubleBackToCloseApp(
                snackBar: const SnackBar(
                  content: Text('Tap back again to leave'),
                  backgroundColor: Colors.redAccent,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                          child: Form(
                        key: formKey,
                        child: Container(
                          //for small
                          width: screenSize.width,
                          height: screenSize.height,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 100),
                                height: 200,
                                child: _isLoading
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Loading...")
                                          ],
                                        ),
                                      )
                                    : Image.asset(
                                        "assets/logos.png",
                                        width: 200.0,
                                      ),
                              ),

                              SizedBox(
                                height: 22,
                              ),
                              Container(
                                //height: 130,
                                width: 320,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),

                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: _txtUser,
                                      obscureText: false,
                                      style: TextStyle(fontSize: 16.0),
                                      validator: validateUsername,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintText: "Username",
                                          prefixIcon: const Icon(
                                            Icons.account_circle,
                                            color: Colors.green,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                    ),
                                    Divider(
                                      color: Colors.transparent,
                                    ),
                                    TextFormField(
                                      controller: _txtPassword,
                                      obscureText: true,
                                      style: TextStyle(fontSize: 16.0),
                                      validator: validatePassword,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.vpn_key,
                                            color: Colors.green,
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintText: "Password",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                    ),
                                  ],
                                ),
                              ),

                              //SizedBox(height: 16,),
                              Container(
                                width: 320,
                                height: 80,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: RaisedButton(
                                    color: Colors.green.shade800,
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        //. request login
                                        Map<String, String> mRequest = {
                                          "cmd": "login",
                                          "user": _txtUser.value.text,
                                          "password": _txtPassword.value.text,
                                        };
                                        util
                                            .httpPost(util.url_api, mRequest)
                                            .then((data) {
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            if (data != null) {
                                              var mData = json.decode(data);
                                              if (mData != null) {
                                                int vStatus = mData["status"];
                                                String vDesc = mData["desc"];
                                                var vData = mData["data"];

                                                if (vStatus == 1) {
                                                  //. save data
                                                  //util.UserData.uidNasabah = '111';
                                                  util.UserData.userName =
                                                      _txtUser.value.text;
                                                  util.UserData.userFullName =
                                                      vData["user_full_name"]
                                                          .toString();
                                                  util.UserData.userSession =
                                                      vData["user_session"]
                                                          .toString();
                                                  //. save to shared pref (untuk autologin, jika session masih valid)
                                                  util.setConfigUser(
                                                      util.UserData.userName);
                                                  util.setConfigSession(util
                                                      .UserData.userSession);
                                                  if (_defaultIndex == 0)
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, "/home");
                                                  print('masuk');
                                                } else {
                                                  showInSnackBar(vDesc);
                                                }
                                              } else {
                                                showInSnackBar(
                                                    "Parsing respond error.");
                                              }
                                            } else {
                                              showInSnackBar(
                                                  "Please check your internet connection.");
                                            }
                                          });
                                        });
                                        setState(() {
                                          _checkSession = false;
                                        });
                                        //Navigator.pushNamed(context, "/home");
                                      }
                                    }),
                              ),

                              Text("User : admin, Pass : 123")
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ));
  }

  @override
  void initState() {
    util.getConfigSession().then((_cfgSession) {
      util.getConfigUser().then((_cfgUser) {
        if (_cfgSession != null && _cfgUser != null) {
          //. test for validation
          Map<String, String> mRequest = {
            "_user": _cfgUser,
            "_session": _cfgSession, //. dialokasikan
            "cmd": "check_session"
          };
          util.httpPost(util.url_api, mRequest).then((data) {
            if (data != null) {
              var mData = json.decode(data);
              if (mData != null) {
                if (mData["status"].toString() == "1") {
                  setState(() {
                    _txtUser.text = "";
                    _txtPassword.text = "";
                    _checkSession = true; //tadinya false
                  });
                  util.UserData.userName = _cfgUser;
                  util.UserData.userSession = _cfgSession;
                  initUniLinks();
                  //Navigator.pushNamed(context, "/home");
                } else {
                  setState(() {
                    _checkSession = false;
                  });
                }
              } else {
                setState(() {
                  _checkSession = false;
                });
              }
            } else {
              setState(() {
                _checkSession = false;
              });
            }
          });
        } else {
          //. sudah pasti tidak valid
          setState(() {
            _checkSession = false;
          });
        }
      });
    });

    super.initState();
  }

  initUniLinks() async {
    try {
      var initialLink = await getInitialLink();
      if (initialLink != null) {
        var a = [];
        var b = [];
        a = initialLink.split('surveyor://send?logs=');
        b.add(a[1]);
        dynamic c = b;
        var dataKtp = json.decode(c[0]);
        var _logID = dataKtp["log_id"].toString();
        print(dataKtp);
        print('asdasdasdsad');
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/home");
      }
    } on PlatformException {
      print('Failed to get initial link.');
    } catch (e) {
      print(e);
    }
  }
}
