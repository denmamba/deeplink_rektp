import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'main.dart';
// ignore: import_of_legacy_library_into_null_safe

class LoginPage extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<LoginPage> {
  final splashDelay = 2000;
  String txtUid = '';
  String txtNik = '';
  String txtNama = '';
  String txtTempatLahir = '';
  String txtTglLahir = '';
  String txtjk = '';
  String txtAlamat = '';
  String txtrt = '';
  String txtrw = '';
  String txtKelurahan = '';
  String txtKecamatan = '';
  String txtAgama = '';
  String txtStatusKawin = '';
  String txtPekerjaan = '';
  String txtWargaNegara = '';
  String txtKota = '';
  String txtPhoto = '';
  String txtTtd = '';

  // ignore: non_constant_identifier_names
  String printer_status = '';
  String prefSerialNumber = '';
  String prefStatusDevice = '';
  String prefRegisterDate = '';
  String prefToken = '';
  String _serialNumber = "Unknown";
  String deviceTokenData = '';
  // ignore: non_constant_identifier_names
  String err_mess = "";
  // ignore: non_constant_identifier_names
  String token_mess = "";
  String txtResponse = "";

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
                        "assets/reKTP-small.png",
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      CircularProgressIndicator(
                        backgroundColor: Colors.orange,
                        color: Colors.yellow,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
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

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //cariSerialNumber();
        initUniLinks();
      }
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      EasyLoading.show(status: 'Check your\ninternet connection!');
      return false;
    }
  }

  Future<void> cariSerialNumber() async {
    try {} on PlatformException {}
    if (!mounted) return;
    setState(() {
      //getPref();
    });

    await FlutterDeviceIdentifier.requestPermission();
    _serialNumber = await FlutterDeviceIdentifier.serialCode;
  }

  savePref(
      String serialNumber, String statusDevice, String registerDate) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("pref_serialNumber", serialNumber);
      preferences.setString('pref_statusDevice', statusDevice);
      preferences.setString("pref_registerDate", registerDate);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      prefSerialNumber = preferences.getString("pref_serialNumber")!;
      prefStatusDevice = preferences.getString('pref_statusDevice')!;
      prefRegisterDate = preferences.getString("pref_registerDate")!;
      prefToken = preferences.getString("pref_authToken")!;
    });
  }

  clearPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("pref_serialNumber", "");
      preferences.setString("pref_statusDevice", "");
      preferences.setString("pref_registerDate", "");
      preferences.setString("pref_authToken", "");
    });
  }

  savePrefToken(String authToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("pref_authToken", authToken);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  Future<void> initUniLinks() async {
    try {
      var initialLink = await getInitialLink();
      print(" inisiallink adalah $initialLink");

      //if (_serialNumber == prefSerialNumber) {
      if (initialLink == null) {
        token_mess = "Retrieve e-KTP";
        print("data ktp blm ada");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(
                      arrKTP: "kosong",
                    )));
      } else {
        //setState(() {
        //getPref();
        // });
        var a = [];
        var b = [];
        a = initialLink.split('rektpsdk://send?logs=');
        b.add(a[1]);
        dynamic c = b;
        var dataKtp = json.decode(c[0]);
        txtUid = dataKtp['uid'].toString();
        txtNik = dataKtp['nik'].toString();
        txtNama = dataKtp['nama'].toString();
        txtTempatLahir = dataKtp["pob"].toString();
        txtTglLahir = dataKtp["dob"].toString();
        txtjk = dataKtp["jenis_kelamin"].toString();
        txtAlamat = dataKtp["alamat"].toString();
        txtrt = dataKtp["rt"].toString();
        txtrw = dataKtp["rw"].toString();
        txtKelurahan = dataKtp["kelurahan_desa"].toString();
        txtKecamatan = dataKtp["kecamatan"].toString();
        txtAgama = dataKtp["agama"].toString();
        txtStatusKawin = dataKtp["status_perkawinan"].toString();
        txtPekerjaan = dataKtp["pekerjaan"].toString();
        txtWargaNegara = dataKtp["kewarganegaraan"].toString();
        txtKota = dataKtp["printed_at"].toString();
        txtPhoto = dataKtp["photo"].toString();
        txtTtd = dataKtp["ttd"].toString();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(
                      arrKTP: "${dataKtp.toString()}",
                      kuid: "${txtUid.toString()}",
                      knik: "${txtNik.toString()}",
                      knama: "${txtNama.toString()}",
                      ktempatLahir: "${txtTempatLahir.toString()}",
                      kTglLahir: "${txtTglLahir.toString()}",
                      kjk: "${txtjk.toString()}",
                      kAlamat: "${txtAlamat.toString()}",
                      krt: "${txtrt.toString()}",
                      krw: "${txtrw.toString()}",
                      kKelurahan: "${txtKelurahan.toString()}",
                      kKecamatan: "${txtKecamatan.toString()}",
                      kAgama: "${txtAgama.toString()}",
                      kStatusKawin: "${txtStatusKawin.toString()}",
                      kPekerjaan: "${txtPekerjaan.toString()}",
                      kWarganegara: "${txtWargaNegara.toString()}",
                      txtSerialNumber: "${prefSerialNumber.toString()}",
                      txtToken: "${prefToken.toString()}",
                      Responsenya: "${dataKtp.toString()}",
                      kKota: "${txtKota.toString()}",
                      kPhoto: "${txtPhoto.toString()}",
                      kTtd: "${txtTtd.toString()}",
                    )));
      }
      //}
    } on PlatformException {
      print('Failed to get initial link.');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      //clearPref();
      hasNetwork();
    });
    //initUniLinks();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigationPage() {
    initUniLinks();
    //Navigator.pushReplacement(context,
    //MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
  }
}
