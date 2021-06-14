import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pegadaian/ambilFoto.dart';

import 'utils.dart' as util;

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  final String uid;
  PreviewScreen({this.imgPath, this.fileName, this.uid});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Preview Photo'),
          automaticallyImplyLeading: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  color: Colors.green,
                  child: Center(
                    child: FlatButton.icon(
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: Text(
                        "Simpan Foto",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        //_pathInWeb.clear();
                        //final bool isMultiPath =
                        //_paths != null && _paths.isNotEmpty;

                        //List<String> lstPath = _paths.values.toList();
                        //for (int i = 0; i < lstPath.length; i++) {
                        final path = widget.imgPath; //lstPath[i];

                        final file = File(path);
                        List<int> contents = file.readAsBytesSync();
                        String base64File = base64Encode(contents);
                        String fileName = path.split("/").last;

                        uploadFile(base64File, fileName).then((result) {});
                        int count = 2;
                        Navigator.of(context).popUntil((_) => count-- <= 0);

                        //Navigator.of(context, rootNavigator: true).pop(context);
                        //Navigator.pop(context);

                        //Navigator.pushReplacementNamed(context, "/home")
                        //.then((value) {
                        //setState(() {
                        // refresh state
                        //});
                        // });
                        //print("ok cupeee" + base64File);
                        //}
                      },
                      /*onPressed: (){
                      getBytes().then((bytes) {
                        print('here now');
                        print(widget.imgPath);
                        print(bytes.buffer.asUint8List());
                        Share.file('Share via', widget.fileName, bytes.buffer.asUint8List(), 'image/path');
                      });
                    },*/
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<String> uploadFile(String contentBase64, String filename) {
    Map<String, String> mRequest = {
      "_user": util.UserData.userName,
      "_session": util.UserData.userSession, //. dialokasikan
      "_uidNasabah": widget.uid,
      "cmd": "upload_file",
      "filedata": contentBase64,
      "filename": filename
    };
    return util.httpPost(util.url_api, mRequest).then((data) {
      var jObject = json.decode(data);
      if (jObject != null) {
        String vDesc = jObject["desc"];
        String vStatus = jObject["status"].toString();
        String vData = jObject["data"].toString();
        String vRetVal = vStatus + "#" + vDesc + "#" + vData;
        return vRetVal;
      } else {
        return "";
      }
    });
  }
}
