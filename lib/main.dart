import 'dart:convert';
import "dart:async";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:meet_network_image/meet_network_image.dart';
import 'package:pegadaian/login.dart';
import 'package:pegadaian/splash.dart';
import 'package:pegadaian/validation_ktp.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'camera.dart';
import 'utils.dart' as util;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pegadaian/transitions/enter_exit_route.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
//import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gadai Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          accentColor: Colors.green.shade500),
      routes: {
        '/': (_) => LoginPage(title: 'Login Gadai Digital'), //SplashScreen(),
        '/home': (_) {
          return MyHomePage(title: 'Gadai Digital');
        },
        //'/upload': (_) => UploadFilePage(),
        //'/detailNasabah': (_) => DetailNasabah(data: '')
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Map rowSiswa;
  final String action; //. pembeda antara "edit" / "new"

  MyHomePage({Key key, this.title, this.rowSiswa, this.action})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Validation {
  bool _ready = false;
  bool _flagAllowSearch = true;
  List<dynamic> _lstDataSiswa = [];
  TextEditingController _txtSearch = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<String> added = [];
  String currentText = "ddd";
  //GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  final currencyFormatter = NumberFormat.currency(locale: 'ID');

  bool _hasilscanKTP = false;
  double persentase;
  double kadarEmasnya;
  String dataku;
  String ktpID = '0';
  String nik;
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
  String _chosenValue;
  String typeBarang = '';
  String hargaJual = '0';
  String pinjaman = '0';
  String nettoBarang = '0';
  String kadarEmas = '0';

  TextEditingController _nik = TextEditingController();
  TextEditingController _nama;
  TextEditingController _alamat;
  TextEditingController _jk;
  TextEditingController _tempatLahir;
  TextEditingController _tglLahir;
  TextEditingController _rt;
  TextEditingController _rw;
  TextEditingController _kelurahan;
  TextEditingController _kecamatan;
  TextEditingController _agama;
  TextEditingController _statusKawin;
  TextEditingController _pekerjaan;
  TextEditingController _wargaNegara;
  TextEditingController _typeBarang;

  TextEditingController _nettoBarang = TextEditingController();
  TextEditingController _hargaJual = TextEditingController();
  TextEditingController _maxPinjaman = TextEditingController();
  TextEditingController _pinjaman = TextEditingController();
  TextEditingController _kadarEmas = TextEditingController();

  int _selectedGadai;
  int _selectedHP;
  int _selectedElektro;
  int _selectedTenor;
  int _biayaAdmin = 25000;

  final formatCurrency =
      new NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '');
  //List<dynamic> _pilGadai = [];
  List<String> _pilGadai = [
    'Perhiasan',
    'Logam Mulia',
    'Handphone',
    'Elektronik',
    'Kendaraan Bermotor',
  ];
  List<dynamic> _merkElektronik = [];
  List<dynamic> _merkHP = [];

  List<double> _persentase = [
    1,
    1,
    0.55,
    0.55,
  ];

  List<int> _tenor = [
    0,
    1,
    2,
    3,
    4,
  ];

  List<dynamic> _kadar = [];
  final List<String> berkas = ['Barang-1', 'Barang-2'];

  @override
  void initState() {
    _loadData().then((d) {
      setState(() {
        initUniLinks();
        _pinjaman.text == '' ? _pinjaman.text = '0' : print("");
        _selectedTenor == null ? _selectedTenor = 0 : print("");
      });
      if (d is String) {
        util.showAlert(context, d, "Alert").then((d) {
          Map<String, String> mRequest = {
            "cmd": "logout",
            "_user": util.UserData.userName,
            "_session": util.UserData.userSession,
          };
          util.httpPost(util.url_api, mRequest).then((data) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
          });
        });
      } else if (d is bool) {}
    });
    _loadElektronik();
    _loadHP();
    super.initState();
  }

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
        duration: const Duration(milliseconds: 4500),
        backgroundColor: Colors.red.shade600,
        content: new Text(value)));
    setState(() {});
  }

  Future<bool> onExitApp(BuildContext context) {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Exit'),
            content: Text('Do you really want to logout?'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  //. logout dulu
                  Map<String, String> mRequest = {
                    "cmd": "logout",
                    "_user": util.UserData.userName,
                    "_session": util.UserData.userSession,
                  };
                  util.httpPost(util.url_api, mRequest).then((data) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()));
                  });
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<dynamic> _loadData() async {
    /*Map<String, String> mPilGadai = {
      "_user": util.UserData.userName,
      "_session": util.UserData.userSession,
      "cmd": "get_pilihan_gadai",
    };

    String dataPilGadai = await util.httpPost(util.url_api, mPilGadai);
    var jPilGadai = json.decode(dataPilGadai);
    if (jPilGadai != null) {
      int vStatus = jPilGadai["status"];
      String vDesc = jPilGadai["desc"];
      var vData = jPilGadai["data"];
      if (vStatus == 1) {
        _pilGadai = vData;
      } else if (vStatus == -99) {
        _pilGadai = [];
        return vDesc;
      } else {
        _pilGadai = [];
      }
    }*/

    return true;
  }

  Future<dynamic> _loadKadarEmas(String search) async {
    Map<String, String> mKadarEmas = {
      "_user": util.UserData.userName,
      "_session": util.UserData.userSession,
      "cmd": "get_pilihan_kadar",
      "search": search,
    };

    String dataKadarEmas = await util.httpPost(util.url_api, mKadarEmas);
    var jKadarEmas = json.decode(dataKadarEmas);
    if (jKadarEmas != null) {
      int vStatus = jKadarEmas["status"];
      String vDesc = jKadarEmas["desc"];
      var vData = jKadarEmas["data"];
      if (vStatus == 1) {
        _kadar = vData;
      } else if (vStatus == -99) {
        _kadar = [];
        return vDesc;
      } else {
        _kadar = [];
      }
    }
    print("pil kadar emas " + _kadar.toString());
    return true;
  }

  Future<dynamic> _loadElektronik() async {
    Map<String, String> mPilElektronik = {
      "_user": util.UserData.userName,
      "_session": util.UserData.userSession,
      "cmd": "get_pilihan_elektronik",
    };

    String dataPilElektronik =
        await util.httpPost(util.url_api, mPilElektronik);
    var jPilElektronik = json.decode(dataPilElektronik);
    if (jPilElektronik != null) {
      int vStatus = jPilElektronik["status"];
      String vDesc = jPilElektronik["desc"];
      var vData = jPilElektronik["data"];
      if (vStatus == 1) {
        _merkElektronik = vData;
      } else if (vStatus == -99) {
        _merkElektronik = [];
        return vDesc;
      } else {
        _merkElektronik = [];
      }
    }
    //print("pil elektro " + _merkElektronik.toString());
    //print("jumlah pilihan gadai " + _pilGadai.length.toString());
    return true;
  }

  Future<dynamic> _loadHP() async {
    Map<String, String> mPilHP = {
      "_user": util.UserData.userName,
      "_session": util.UserData.userSession,
      "cmd": "get_pilihan_hp",
    };

    String dataPilHP = await util.httpPost(util.url_api, mPilHP);
    var jPilHP = json.decode(dataPilHP);
    if (jPilHP != null) {
      int vStatus = jPilHP["status"];
      String vDesc = jPilHP["desc"];
      var vData = jPilHP["data"];
      if (vStatus == 1) {
        _merkHP = vData;
      } else if (vStatus == -99) {
        _merkHP = [];
        return vDesc;
      } else {
        _merkHP = [];
      }
    }
    //print("pil HP " + _merkHP.toString());
    return true;
  }

  Future<dynamic> _refreshData() async {
    setState(() {
      showInSnackBar("yutiyuiuyi");
    });

    /*Map<String, String> mRequest = {
      "_user": util.UserData.userName,
      "_session": util.UserData.userSession,
      "cmd": "get_data_perhalaman",
      "search": search,
      "limit": limit
    };

    String data = await util.httpPost(util.url_api, mRequest);
    _ready = true;
    var jObject = json.decode(data);
    if (jObject != null) {
      int vStatus = jObject["status"];
      String vDesc = jObject["desc"];
      //String v_cmd = jObject["cmd"];
      var vData = jObject["data"];
      if (vStatus == 1) {
        //. success
        _lstDataSiswa = vData;
      } else if (vStatus == -99) {
        //. expired
        _lstDataSiswa = [];
        return vDesc;
      } else {
        _lstDataSiswa = [];
      }
    }*/

    return true;
  }

  /*List<Widget> _getRows() {
    List<Widget> lstRow = [];
    for (int i = 0; i < _lstDataSiswa.length; i++) {
      var nomor = i + 1;
      dynamic _r = _lstDataSiswa[i];
      lstRow.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Wrap(
                        spacing: 5.0, // gap between adjacent chips
                        runSpacing: 1.0, // gap between lines
                        direction:
                            Axis.horizontal, // main axis (rows or columns)
                        children: <Widget>[
                          new Chip(
                              backgroundColor: Colors.blue.shade900,
                              label: new Text(nomor.toString(),
                                  style: TextStyle(color: Colors.white))),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text("NAMA"),
                      Divider(
                        color: Colors.grey,
                      ),
                      new Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(_r["nama"].toString(),
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("RUMAH"),
                      Divider(
                        color: Colors.grey,
                      ),
                      new Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(_r["alamat"].toString(),
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("KANTOR"),
                      Divider(
                        color: Colors.grey,
                      ),
                      new Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(_r["alamat"].toString(),
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("WAKTU PICKUP"),
                      Divider(
                        color: Colors.grey,
                      ),
                      Text(_r["jk"].toString()),
                      SizedBox(height: 25),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Text(
                            "+ Pickup Document",
                            style: TextStyle(fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: null,
                                  enterPage: DetailNasabah(
                                    data: _r["id"].toString() +
                                        "|" +
                                        _r["nama"].toString() +
                                        "|" +
                                        _r["alamat"].toString() +
                                        "|" +
                                        _r["jk"].toString(),
                                  )),
                              /*MaterialPageRoute(
                                    builder: (context) => DetailNasabah(
                                      data: _r["id"].toString() +
                                          "|" +
                                          _r["nama"].toString() +
                                          "|" +
                                          _r["alamat"].toString() +
                                          "|" +
                                          _r["jk"].toString(),
                                    ),
                                  )*/
                            );
                          },
                          color: Colors.green.shade900,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.green,
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                )),
          ],
        ),
      );
    }

    if (_lstDataSiswa.length == 0) {
      //. no data
      lstRow.add(Container(
        height: 400,
        child: Center(
          child: Text(
            "Data Kosong",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.withOpacity(0.7)),
          ),
        ),
      ));
    }

    return lstRow;
  }*/

  /*Widget _getTable() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: _ready == true
            ? _getRows()
            : <Widget>[
                Container(
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ))
              ],
      ),
    );
  }*/

  List<String> lstRow = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    //var _limit = _getRows().length + 1;
    //showInSnackBar("Data");
    _refreshData().then((d) {
      setState(() {});
    });
    _refreshController.refreshCompleted();
  }

  /*void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    //var _limit = _getRows().length + 1;
    //showInSnackBar("Data");
    _refreshData().then((d) {
      setState(() {});
    });
    _refreshController.loadComplete();
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onExitApp(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[_scanKTP()],
        ),
        body: SmartRefresher(
            enablePullDown: false,
            enablePullUp: false,
            header: WaterDropHeader(),
            controller: _refreshController,
            //onRefresh: _onRefresh,
            //onLoading: _onLoading,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_formPengajuan()],
                ))),
      ),
    );
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
        _nik = TextEditingController(text: dataKtp["nik"].toString());
        _nama = TextEditingController(text: dataKtp["nama"].toString());
        _tempatLahir = TextEditingController(text: dataKtp["pob"].toString());
        _tglLahir = TextEditingController(text: dataKtp["dob"].toString());
        _jk = TextEditingController(text: dataKtp["jenis_kelamin"].toString());
        _alamat = TextEditingController(text: dataKtp["alamat"].toString());
        _rt = TextEditingController(text: dataKtp["rt"].toString());
        _rw = TextEditingController(text: dataKtp["rw"].toString());
        _kelurahan =
            TextEditingController(text: dataKtp["kelurahan_desa"].toString());
        _kecamatan =
            TextEditingController(text: dataKtp["kecamatan"].toString());
        _agama = TextEditingController(text: dataKtp["agama"].toString());
        _statusKawin = TextEditingController(
            text: dataKtp["status_perkawinan"].toString());
        _pekerjaan =
            TextEditingController(text: dataKtp["pekerjaan"].toString());
        _wargaNegara =
            TextEditingController(text: dataKtp["kewarganegaraan"].toString());

        FocusScope.of(context).nextFocus();
        print('datanya $dataKtp');
        _hasilscanKTP = true;
        //await prefs.setInt('dataKtp', dataKtp);
      } else {
        _hasilscanKTP = true;
        print('hasil scan ktp false');
      }
    } on PlatformException {
      print('Failed to get initial link.');
    } catch (e) {
      print(e);
    }
  }

  Widget _scanKTP() {
    return FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.green,
        textColor: Colors.white,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.green.shade400,
        onPressed: () => android_intent.Intent()
          ..setAction(android_action.Action.ACTION_VIEW)
          ..setData(Uri.parse("rektp://read?log_id=1"))
          ..startActivityForResult().then(
            (logs) => print(logs),
            onError: (e) => print(e.toString()),
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.scanner),
            SizedBox(width: 9),
            Text('Scan KTP')
          ],
        ));
  }

  Widget _formPengajuan() {
    return DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
          backgroundColor: Colors.redAccent,
        ),
        child: SingleChildScrollView(
            reverse: true,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                    key: formKey, //MENGGUNAKAN GLOBAL KEY
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 30),
                              nikField(),
                              SizedBox(height: 10),
                              nameField(),
                              SizedBox(height: 10),
                              tgllahirField(),
                              SingleChildScrollView(
                                child: Column(children: <Widget>[
                                  Column(
                                    //shrinkWrap: true,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Layanan Gadai'),
                                      ),
                                      Container(
                                        height: 50.0,
                                        child: new ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: <Widget>[
                                              Container(
                                                height: 30,
                                                child:
                                                    _buildChipsGadai(context),
                                              ),
                                            ]),
                                      ),
                                      _selectedGadai == 2
                                          ? Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text('Merk'),
                                                ),
                                                Container(
                                                  height: 50.0,
                                                  child: new ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 30,
                                                          child: _buildChipsHP(
                                                              context),
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            )
                                          : Text(''),
                                      _selectedGadai == 3
                                          ? Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text('Merk'),
                                                ),
                                                Container(
                                                  height: 50.0,
                                                  child: new ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 30,
                                                          child:
                                                              _buildChipsElektro(
                                                                  context),
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            )
                                          : Text(''),
                                    ],
                                  ),
                                ]),
                              ),
                              _selectedGadai == 0 || _selectedGadai == 1
                                  ? Column(
                                      children: <Widget>[
                                        SizedBox(height: 15),
                                        kadarEmasField(),
                                        SizedBox(height: 15),
                                        nettoField(),
                                        SizedBox(height: 15),
                                      ],
                                    )
                                  : SizedBox(height: 0),
                              _selectedGadai == 2 || _selectedGadai == 3
                                  ? _selectedElektro != null ||
                                          _selectedHP != null
                                      ? Column(
                                          children: <Widget>[
                                            SizedBox(height: 15),
                                            typeBarangField(),
                                            SizedBox(height: 15),
                                            hargaPasarField(_selectedGadai),
                                            SizedBox(height: 15),
                                          ],
                                        )
                                      : SizedBox(height: 0)
                                  : SizedBox(height: 0),
                              ketPinjamanMax(),
                              SizedBox(height: 20),
                              pinjamanField(),
                              SizedBox(height: 20),
                              Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text('Tenor'),
                                  ),
                                  Container(
                                    height: 50.0,
                                    child: new ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          Container(
                                            height: 30,
                                            child: _buildChipsTenor(context),
                                          ),
                                        ]),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              _selectedTenor > 0
                                  ? ketCicilan()
                                  : SizedBox(height: 0),
                              SizedBox(height: 20),
                              _nik.text != ''
                                  ? fotoProduk()
                                  : SizedBox(height: 0),
                              SizedBox(height: 20),

                              //loadButton(context),
                              _hasilscanKTP == true
                                  ? saveButton(context)
                                  : SizedBox(height: 0),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                        SizedBox(height: 15)
                      ],
                    )))));
  }

  Widget saveButton(context) {
    //var aRow = widget.data.split("|");
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.green.shade700,
        textColor: Colors.white,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.green.shade500,
        onPressed: () {
          if (formKey.currentState.validate()) {
            //showInSnackBar(
            //"Gadai Digital ini masih versi SIMULASI, sehingga data tidak bisa diteruskan ke server.");
            FocusScope.of(context).unfocus();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                final theme = Theme.of(context);
                return SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 30),
                    printButton(context),
                    SizedBox(height: 30),
                  ]),
                );
              },
            );
            /*
            formKey.currentState.save(); //MAKA FUNGSI SAVE() DIJALANKAN
            Map<String, String> mRequest = {
              "_user": util.UserData.userName,
              "_session": util.UserData.userSession, //. dialokasikan
              "cmd": "update_data",
              //"id": _id, //. ignored when *new* in server
              //"nik": _nik,
            };
            util
                .showAlert(
                    context, "Update data $nama, are you sure ?", "Confirm")
                .then((b) {
              if (b == true) {
                util.showLoading(context, true);
                util.httpPost(util.url_api, mRequest).then((data) {
                  util.showLoading(context, false);
                  print(data);
                  var jObject = json.decode(data);
                  if (jObject != null) {
                    String vDesc = jObject["desc"];
                    //String vStatus = jObject["status"].toString();
                    //String vRetVal = vStatus + "#" + vDesc;
                    formKey.currentState.reset();
                    //. return
                    //Navigator.pop(context, vRetVal);
                    FocusManager.instance.primaryFocus.unfocus();
                    showInSnackBar(vDesc);
                  }
                });
              }
            });*/
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.cloud_download),
            SizedBox(width: 9),
            Text('Proses Gadai')
          ],
        ));
  }

  Widget printButton(context) {
    return Container(
        margin: EdgeInsets.all(25.0),
        child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.green)),
            color: Colors.white,
            textColor: Colors.green,
            padding: EdgeInsets.all(15.0),
            splashColor: Colors.grey.shade200,
            onPressed: () {
              Navigator.of(context).pop();

              //showInSnackBar(
              //"Gadai Digital ini masih versi SIMULASI, sehingga data tidak bisa diteruskan ke server.");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.print),
                SizedBox(width: 9),
                Text('Cetak Struk')
              ],
            )));
  }

  Widget fotoProduk() {
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
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.grey.shade400,
                  //elevation: 2,
                  child: Column(children: <Widget>[
                    Expanded(
                      child: MeetNetworkImage(
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        imageUrl: 'https://infiplus.net/flutter/fotoGadai/' +
                            ktpID +
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                    //data: 'data',
                                    jenisFoto: item.toString(),
                                    uid: ktpID),
                              ));
                        },
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 33,
                        ),
                        label: Text('Ambil Foto ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14))),
                  ])),
            ))
        .toList();

    return SingleChildScrollView(
        reverse: true,
        child: Container(
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              height: MediaQuery.of(context).size.height * 0.3,
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
              viewportFraction: 0.6,
              initialPage: 0,
            ),
            items: imageSliders,
          ),
        ));
    //endingnya

    //SizedBox(height: 15)
    //],
    // ))));
  }

  Widget _buildChipsGadai(context) {
    List<Widget> chips = new List();
    for (int i = 0; i < _pilGadai.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedGadai == i,
        label: Text(_pilGadai[i],
            style: _selectedGadai == i
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black)),
        avatar: _selectedGadai == i ? Icon(Icons.check) : null,
        pressElevation: 5,
        shape: StadiumBorder(side: BorderSide(color: Colors.green)),
        backgroundColor: Colors.transparent,
        selectedColor: Colors.green,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedGadai = i;
              print("nik adalah " + _nik.text);
              print("$i " + _pilGadai[i]);
              _hargaJual.text = '0';
              _maxPinjaman.text = '';
              _nettoBarang.text = '';
              _selectedGadai == 1
                  ? _kadarEmas.text = '24'
                  : _kadarEmas.text = '18';
              _selectedHP = null;
              _selectedElektro = null;
            }
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }
    return Row(
      children: chips,
    );
  }

  Widget _buildChipsElektro(context) {
    List<Widget> chips2 = new List();
    for (int j = 0; j < _merkElektronik.length; j++) {
      dynamic _pElektro = _merkElektronik[j];
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedElektro == j,
        label: Text(_pElektro["merk_elektro"].toString(),
            style: _selectedElektro == j
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black)),
        avatar: _selectedElektro == j ? Icon(Icons.check) : null,
        pressElevation: 5,
        shape: StadiumBorder(side: BorderSide(color: Colors.green)),
        backgroundColor: Colors.transparent,
        selectedColor: Colors.green,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedElektro = j;
              print(_pElektro["merk_elektro"].toString());
            }
          });
        },
      );

      chips2.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }
    return Row(
      children: chips2,
    );
  }

  Widget _buildChipsHP(context) {
    List<Widget> chips3 = new List();
    for (int k = 0; k < _merkHP.length; k++) {
      dynamic _pilihanHP = _merkHP[k];
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedHP == k,
        label: Text(_pilihanHP["merk_hp"].toString(),
            style: _selectedHP == k
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black)),
        avatar: _selectedHP == k ? Icon(Icons.check) : null,
        pressElevation: 5,
        shape: StadiumBorder(side: BorderSide(color: Colors.green)),
        backgroundColor: Colors.transparent,
        selectedColor: Colors.green,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedHP = k;
              print(_pilihanHP["merk_hp"].toString());
            }
          });
        },
      );

      chips3.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }
    return Row(
      children: chips3,
    );
  }

  Widget _buildChipsTenor(context) {
    List<Widget> chips = new List();
    for (int m = 0; m < _tenor.length; m++) {
      if (m > 0) {
        ChoiceChip choiceChip = ChoiceChip(
          selected: _selectedTenor == m,
          label: Text(_tenor[m].toString() + " bulan",
              style: _selectedTenor == m
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black)),
          avatar: _selectedTenor == m ? Icon(Icons.check) : null,
          pressElevation: 5,
          shape: StadiumBorder(side: BorderSide(color: Colors.green)),
          backgroundColor: Colors.transparent,
          selectedColor: Colors.green,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedTenor = m;
                print("tenor " + _tenor[m].toString());
                _selectedGadai == 1
                    ? _kadarEmas.text = '24'
                    : _kadarEmas.text = '18';
                _selectedHP = null;
                _selectedElektro = null;
              }
            });
          },
        );

        chips.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
      }
    }
    return Row(
      children: chips,
    );
  }

  Widget changeHarga() {
    var txtKadarEmas = (_kadarEmas.text).replaceAll(".", "");
    persentase = _persentase[_selectedGadai];
    _loadKadarEmas(txtKadarEmas).then((d) {
      setState(() {
        dynamic _txtKadar = _kadar[0];
        kadarEmasnya = double.parse(_txtKadar["harga_gramasi"]);
        _calculate(persentase, _selectedGadai, kadarEmasnya);
      });
    });
  }

  Widget nikField() {
    return TextFormField(
      controller: _nik,
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        labelText: 'NIK',
        hintText: 'Nomor KTP',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.credit_card,
          color: Colors.green,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator:
          validateNik, //validateName ADALAH NAMA FUNGSI PADA FILE validation.dart
      onSaved: (String value) {
        //KETIKA LOLOS VALIDASI
        nik = nik;
      },
      onChanged: (value) {
        ktpID = value;
      },
    );
  }

  Widget nameField() {
    return TextFormField(
      controller: _nama,
      decoration: new InputDecoration(
        labelText: 'Nama Lengkap',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.green,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator:
          validateName, //validateName ADALAH NAMA FUNGSI PADA FILE validation.dart
      onSaved: (String value) {
        //KETIKA LOLOS VALIDASI
        nama =
            value; //MAKA VARIABLE name AKAN DIISI DENGAN TEXT YANG TELAH DI-INPUT
      },
    );
  }

  Widget tgllahirField() {
    //MEMBUAT TEXT INPUT
    return TextFormField(
      controller: _tglLahir,
      keyboardType: TextInputType.datetime,
      decoration: new InputDecoration(
        labelText: 'Tanggal Lahir',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.date_range,
          color: Colors.green,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator:
          validateTglLahir, //validateName ADALAH NAMA FUNGSI PADA FILE validation.dart
      onSaved: (String value) {
        //KETIKA LOLOS VALIDASI
        tglLahir =
            value; //MAKA VARIABLE name AKAN DIISI DENGAN TEXT YANG TELAH DI-INPUT
      },
    );
  }

  Widget typeBarangField() {
    return TextFormField(
      controller: _typeBarang,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(50),
      ],
      decoration: new InputDecoration(
        labelText: 'Type  Barang',
        hintText: 'Jenis  Barang',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.assignment,
          color: Colors.green,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator:
          validateTypeBarang, //validateName ADALAH NAMA FUNGSI PADA FILE validation.dart
      onSaved: (String value) {
        //KETIKA LOLOS VALIDASI
        typeBarang =
            value; //MAKA VARIABLE name AKAN DIISI DENGAN TEXT YANG TELAH DI-INPUT
      },
    );
  }

  Widget nettoField() {
    return TextFormField(
      controller: _nettoBarang,
      keyboardType: TextInputType.number,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(3),
      ],
      decoration: new InputDecoration(
        labelText: 'Netto (gram)',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.card_giftcard,
          color: Colors.green,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validateNettoBarang,
      onChanged: (value) {
        changeHarga();
      },
    );
  }

  Widget kadarEmasField() {
    return TextFormField(
      controller: _kadarEmas,
      keyboardType: TextInputType.number,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(2),
      ],
      decoration: new InputDecoration(
        labelText: 'Kadar Emas (karat)',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.data_usage,
          color: Colors.green,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validateKadarEmas,
      onSaved: (String value) {
        kadarEmas = value;
      },
      onChanged: (value) {
        changeHarga();
      },
    );
  }

  Widget hargaPasarField(_selectedGadai) {
    return TextFormField(
      controller: _hargaJual,
      keyboardType: TextInputType.number,
      inputFormatters: [
        new LengthLimitingTextInputFormatter(11),
        CurrencyTextInputFormatter(
          locale: 'ID',
          decimalDigits: 0,
        )
      ],
      decoration: new InputDecoration(
        labelText: 'Harga Jual Saat ini',
        hintText: 'Harga Taksiran / Harga Jual',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.account_balance_wallet,
          color: Colors.green,
        ),
        prefixText: 'Rp ',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validateHargaJual,
      onChanged: (value) {
        changeHarga();
      },
    );
  }

  Widget pinjamanField() {
    return TextFormField(
      controller: _pinjaman,
      inputFormatters: [
        CurrencyTextInputFormatter(
          locale: 'ID',
          decimalDigits: 0,
        )
      ],
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        labelText: 'Jumlah Pinjaman',
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: const Icon(
          Icons.account_balance_wallet,
          color: Colors.green,
        ),
        prefixText: 'Rp ',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validatePinjaman,
      onSaved: (String value) {
        //KETIKA LOLOS VALIDASI
        pinjaman = value;
      },
      onChanged: (value) {
        _cekPinjaman();
      },
    );
  }

  Widget ketPinjamanMax() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            AbsorbPointer(
              child: TextFormField(
                controller: _maxPinjaman,
                decoration: new InputDecoration(
                  labelText: 'Pinjaman Maksimal',
                  prefixIcon: const Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    locale: 'ID',
                    decimalDigits: 0,
                  )
                ],
                validator: validatePinjamanMax,
              ),
            ),
            //SizedBox(height: 20),
            /*Text(
                "Jangka waktu maksimal 4 bulan (120) hari bisa dicicil atau dilunasi kapan saja. \n\nPerkiraan Pinjaman diatas dapat berubah tergantung kondisi dan kelengkapan barang serta harga pasar terkini."),
          */
          ],
        ));
  }

  Widget ketCicilan() {
    var rep_pinjaman = _pinjaman.text.replaceAll(".", "");
    var bungaPinjam = double.parse(rep_pinjaman) * 0.0295 * (_selectedTenor);
    var totPinjam = double.parse(rep_pinjaman) + _biayaAdmin + bungaPinjam;
    var cicilan1 = (double.parse(rep_pinjaman) / (_selectedTenor)) +
        _biayaAdmin +
        bungaPinjam;
    var cicilan2 =
        (double.parse(rep_pinjaman) / (_selectedTenor)) + bungaPinjam;
    var cicilanNext = _selectedTenor == 0 ? 0 : cicilan2;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          color: Colors.grey.shade200,
          width: 10,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text("DETAIL\n==============="),
                    SizedBox(height: 10),
                    Text("Pinjaman"),
                    SizedBox(height: 10),
                    Text("Biaya Admin"),
                    SizedBox(height: 10),
                    Text("Bunga Pinjaman (2.95%) "),
                    SizedBox(height: 10),
                    Text("Total Pinjaman"),
                    SizedBox(height: 10),
                    Text("Cicilan ke-1"),
                    SizedBox(height: 10),
                    Text("Cicilan selanjutnya "),
                    SizedBox(height: 10),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(""),
                    SizedBox(height: 25),
                    Text(": Rp " + _pinjaman.text),
                    SizedBox(height: 10),
                    Text(": Rp " + formatCurrency.format(_biayaAdmin)),
                    SizedBox(height: 10),
                    Text(": Rp " + formatCurrency.format(bungaPinjam)),
                    SizedBox(height: 10),
                    Text(": Rp " + formatCurrency.format(totPinjam)),
                    SizedBox(height: 10),
                    Text(": Rp " + formatCurrency.format(cicilan1)),
                    SizedBox(height: 10),
                    Text(": Rp " + formatCurrency.format(cicilanNext)),
                    SizedBox(height: 10),
                  ],
                )
              ],
            ),
          ]),
    );
  }

  void _calculate(double pengali, jenisGadai, kadarEmasnya) {
    if (jenisGadai < 2) {
      if (_hargaJual.text.trim().isNotEmpty &&
          _nettoBarang.text.trim().isNotEmpty) {
        final netto = (_nettoBarang.text).replaceAll(".", "");
        //final hargaJualValue = (_hargaJual.text).replaceAll(".", "");
        double konv_harga = double.parse(netto) * kadarEmasnya;
        _maxPinjaman.text = (formatCurrency.format(konv_harga)).toString();
      }
    } else {
      if (_hargaJual.text.trim().isNotEmpty) {
        final hargaJualValue = (_hargaJual.text).replaceAll(".", "");
        double konv_harga = double.parse(hargaJualValue) * pengali;
        _maxPinjaman.text = (formatCurrency.format(konv_harga)).toString();
      }
    }
  }

  void _cekPinjaman() {
    var rep_pinjaman = _pinjaman.text.replaceAll(".", "");
    var rep_maxPinjaman = _maxPinjaman.text.replaceAll(".", "");
    if (double.parse(rep_pinjaman) > double.parse(rep_maxPinjaman)) {
      showInSnackBar("Pinjaman melebihi " + _maxPinjaman.text);
      _pinjaman.text = 0.toString();
    }
  }
}
