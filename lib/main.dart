import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:test_deeplink/splash.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:lumberdash/lumberdash.dart';
import 'package:file_lumberdash/file_lumberdash.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

const _url = 'rektp://read?type=0';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOG EKTP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
              .copyWith(secondary: Colors.orange)),
      routes: {
        '/': (_) => LoginPage(),
      },
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? kodenik;
  final String? arrKTP;
  final String? arrDeviceToken;
  final String? kuid;
  final String? knik;
  final String? knama;
  final String? ktempatLahir;
  final String? kTglLahir;
  final String? kjk;
  final String? kAlamat;
  final String? krt;
  final String? krw;
  final String? kKelurahan;
  final String? kKecamatan;
  final String? kAgama;
  final String? kStatusKawin;
  final String? kPekerjaan;
  final String? kWarganegara;
  final String? kKota;
  final String? kPhoto;
  final String? kTtd;
  final String? txtSerialNumber;
  final String? txtToken;
  // ignore: non_constant_identifier_names
  final String? Responsenya;

  MyHomePage({
    Key? key,
    this.kodenik,
    this.arrKTP,
    this.arrDeviceToken,
    this.kuid,
    this.knik,
    this.knama,
    this.ktempatLahir,
    this.kTglLahir,
    this.kjk,
    this.kAlamat,
    this.krt,
    this.krw,
    this.kKelurahan,
    this.kKecamatan,
    this.kAgama,
    this.kStatusKawin,
    this.kPekerjaan,
    this.kWarganegara,
    this.txtSerialNumber,
    this.txtToken,
    // ignore: non_constant_identifier_names
    this.Responsenya,
    this.kKota,
    this.kPhoto,
    this.kTtd,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();

  List<String> added = [];
  //List<dynamic> _listDataKTP = [];
  late String currentText;

  late String dataku;
  String ktpID = '0';
  String kodesdb = '';
  late String nokunci;
  late String nik;
  late String txtSDBMaster;
  late String txtKunciMaster;
  String nama = '';
  String alamat = '';
  String jk = '';
  String tempatLahir = '';
  String tglLahir = '';
  String rt = '';
  String rw = '';
  String kelurahan = '';
  String kecamatan = '';
  String agama = '';
  String statusKawin = '';
  String pekerjaan = '';
  String wargaNegara = '';

  // ignore: non_constant_identifier_names
  String waiting_message = '';
  // ignore: non_constant_identifier_names
  String response_message = '';
  var tampilDaftarBaru;
  var pecahKTP = '';
  var dataKtp;
  List<Map<String, dynamic>> dataKyc = [];
  String dummyData = '';
  //final DbHelper _helper = new DbHelper();

  //List<BluetoothDevice> _devices = [];
  late String pathImage;
  // ignore: non_constant_identifier_names
  String printer_status = '';
  int prefReqScan = 0;

  get imagen => null;

  @override
  void initState() {
    if (widget.knik != null) {
      dataektp();
      getPref();
    }
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  dataektp() async {
    _requestApi();
    String _fullName = widget.knama.toString();

    Directory? appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir!.path;
    final currentDate = DateTime.now();
    final fileName =
        '${currentDate.year}-${currentDate.month}-${currentDate.day}-${currentDate.microsecond}-$_fullName-logs';
    putLumberdashToWork(withClients: [
      FileLumberdash(
        filePath: '$appDocPath/$fileName.txt',
      ),
    ]);
    print('save file to $appDocPath/$fileName.txt');
    logMessage('${widget.arrKTP.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('LOG EKTP DEMO VERSION'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: <Widget>[
              _formPengajuan(),
            ],
          )),
    );
  }

  Widget _formPengajuan() {
    return SingleChildScrollView(
        reverse: true,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
                key: formKey, //MENGGUNAKAN GLOBAL KEY
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 50),
                          (waiting_message == "")
                              ? Text(
                                  'Silahkan tekan tombol Scan KTP-el untuk memulai pembacaan.',
                                  textAlign: TextAlign.center,
                                )
                              : Text(''),
                          SizedBox(height: 20),
                          Text("=============================="),
                          Text("${widget.Responsenya.toString()}"),
                          Text("=============================="),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 150,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (prefReqScan > 5) {
                                            EasyLoading.showError(
                                                "Limit scan habis.\nSilahkan clear cache apps\nterlebih dahulu.");
                                          } else {
                                            getPref();
                                            var hasilPref = prefReqScan + 1;
                                            savePref(hasilPref);
                                            print("hasil pref $hasilPref");
                                            _connectRektp();
                                          }
                                        });
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Icon(
                                                Icons.scanner,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text('Scan KTP-el'),
                                          ]))),
                              SizedBox(width: 10),
                            ],
                          ),
                          SizedBox(height: 40),

                          //Text('{{Status printer: $printer_status }}'),
                        ],
                      ),
                    )
                  ],
                ))));
  }

  // ignore: deprecated_member_use
  void _connectRektp() async => await canLaunch(_url)
      // ignore: deprecated_member_use
      ? await launch(_url)
      : throw 'Could not launch $_url';

  savePref(int reqScan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("jum_req_scan", reqScan);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      prefReqScan = preferences.getInt("jum_req_scan");
    });
  }

  Widget getImagenBase64(String thumbnail) {
    Uint8List _bytes;
    String placeholder =
        "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";
    if (thumbnail.isEmpty)
      thumbnail = placeholder;
    else {
      if (thumbnail.length % 4 > 0) {
        thumbnail +=
            '=' * (4 - thumbnail.length % 4); // as suggested by Albert221
      }
    }
    _bytes = Base64Decoder().convert(thumbnail);
    return Image.memory(
      _bytes,
      width: 100,
      fit: BoxFit.fitWidth,
    );
  }

  _requestApi() async {
    //String _nik = widget.knik.toString();
    //String _fullName = widget.knama.toString();
    String _bornDate = widget.kTglLahir.toString();
    //String _placeOfBirth = widget.ktempatLahir.toString();
    String _gender = (widget.kjk == "PEREMPUAN") ? "female" : "male";
    //String _address = widget.kAlamat.toString();
    //String _district = widget.kKecamatan.toString();
    //String _subDistrict = widget.kKelurahan.toString();
    //String _rt = widget.krt.toString();
    //String _rw = widget.krw.toString();
    //String _religion = widget.kAgama.toString();
    //String _maritalStatus = widget.kStatusKawin.toString();
    //String _profession = widget.kPekerjaan.toString();
    // String _citizen = widget.kWarganegara.toString();
    //String _terminalId = "${prefSerialNumber.toString()}";
    //String _photo = widget.kPhoto.toString();
    //String _signature = widget.kTtd.toString();
    String date = _bornDate.toString();
    final dateList = date.split("-");
    String txtTgl =
        (dateList[0].length > 1) ? "${dateList[0]}" : "0${dateList[0]}";
    String txtBulan =
        (dateList[1].length > 1) ? "${dateList[1]}" : "0${dateList[1]}";
    String txtTahun = "${dateList[2]}";
    String _bod = "$txtTahun-$txtBulan-$txtTgl";

    setState(() {
      waiting_message = "Send data to API...";
    });

    var keyBody2 =
        '{"nik": "${widget.knik.toString()}","name": "${widget.knama.toString()}","bornDate": "${_bod.toString()}","placeOfBirth": "${widget.ktempatLahir.toString()}","gender": "${_gender.toString()}", "address": "${widget.kAlamat.toString()}","rt": "${widget.krt.toString()}","rw": "${widget.krw.toString()}","subDistrict": "${widget.kKelurahan.toString()}", "district": "${widget.kKecamatan.toString()}", "religion": "${widget.kAgama.toString()}","maritalStatus": "${widget.kStatusKawin.toString()}","profession": "${widget.kPekerjaan.toString()}","citizen": "${widget.kWarganegara.toString()}", "province": "", "city": "", "photo": "${widget.kPhoto.toString()}","vendor": "ATT","terminalId": "${widget.txtSerialNumber.toString()}"}';

    print("Value:$keyBody2");
    //print("nik ${widget.knik.toString()}");
    setState(() {
      /*response_message =
          "Headers: ${response.headers}\n\nUrl: ${response.request}\n\nAuth: ${response.request.headers}\n\nValue:${keyBody2}\n\nBody: ${response.body}\n\n>>${response.statusCode}";
      */
    });
  }
}
