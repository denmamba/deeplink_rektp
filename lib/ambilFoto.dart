import 'package:flutter/material.dart';
import 'validation_ktp.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pegadaian/camera.dart';
import 'package:meet_network_image/meet_network_image.dart';

final List<String> berkas = ['Dokumen', 'Rumah', 'Kantor'];

final List<String> imgDoc = [
  'http://infiplus.net/flutter/upload/2_5c59f_Dokumen_2021-03-26%2008:55:37.339691.png',
  'Rumah',
  'Kantor'
];

// ignore: must_be_immutable
class AmbilFoto extends StatelessWidget with Validation {
  final String data;
  final String url = "http://via.placeholder.com/";
  // receive data from the FirstScreen as a parameter
  AmbilFoto({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var aRow = data.split("|");
    //var _image;
    final List<Widget> imageSliders = berkas
        .map((item) => SizedBox(
              //height: double.infinity,
              //color: Colors.red,
              //height: double.infinity,
              //margin: EdgeInsets.all(5.0),

              child: new Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.pink,
                  elevation: 2,
                  child: Column(children: <Widget>[
                    Expanded(
                      child: MeetNetworkImage(
                        fit: BoxFit.cover,
                        width: 350,
                        imageUrl: 'http://infiplus.net/flutter/upload/' +
                            aRow[0] +
                            '_' +
                            item.toString() +
                            '.png',
                        loadingBuilder: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorBuilder: (context, e) => Container(
                          child: Text('Error appear!'),
                        ),
                      ),
                    ),
                    ////aRow[0] == null ? 'assets/logos.png' : 'http://infiplus.net/flutter/upload/' + aRow[0] +'_' +item.toString() +'.png'
                    FlatButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                    // data: data,
                                    jenisFoto: item.toString(),
                                    uid: aRow[0]),
                              ));
                        },
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 33,
                        ),
                        label: Text('Foto ' + item.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18))),
                  ])),
            ))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Capture Photo')),
      body: SingleChildScrollView(
          reverse: true,
          child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 33),
                  Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: false,
                        height: MediaQuery.of(context).size.height * 0.7,
                        aspectRatio: 1,
                        enlargeCenterPage: true,
                      ),
                      items: imageSliders,
                    ),
                  ),
                  //endingnya

                  SizedBox(height: 15)
                ],
              )))),
    );
  }
}
