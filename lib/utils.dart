import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url_api =
    "https://infiplus.net/flutter/services.gadai.digital.php";

class UserData {
  static String userName = "";
  static String userFullName = "";
  static String userSession = "";
  //static String uidNasabah = "";
}

void setConfigUser(String _user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('c_user', _user);
}

Future<String> getConfigUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _data = prefs.getString('c_user');
  return _data;
}

void setConfigSession(String _user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('c_session', _user);
}

Future<String> getConfigSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _data = prefs.getString('c_session');
  return _data;
}

void showLoading(context, b) async {
  if (b)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  else
    Navigator.pop(context);
}

Future<bool> showAlert(BuildContext context, String text, String title) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future httpPost(String url, Map<String, String> params) async {
  try {
    final response = await http.post(url, body: params);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      //throw Exception('Failed to load post');
      return null;
    }
  } catch (e) {
    return null;
  }
}
