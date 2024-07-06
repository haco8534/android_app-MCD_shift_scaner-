// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mcd_app/calender.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mcd_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/date_model.dart';
import 'setting.dart';
import 'functions/set_color.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirstLunch = await isFirstLaunch();
  if(isFirstLunch){
    
  }
  else{
    ColorScheme ThemeColor = await setColor();
    await initializeDateFormatting().then((_) => runApp(MyApp(initialThemeColor:ThemeColor)));
  }
}

//初回起動時の設定
Future<bool> isFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  if (isFirstLaunch) {
    prefs.setBool('isFirstLaunch',false);
    prefs.setString('ThemeColor','ブルー');
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatefulWidget {
  final ColorScheme initialThemeColor;

  const MyApp({super.key, required this.initialThemeColor});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  //ColorScheme ThemeColor = ColorScheme.fromSeed(seedColor: Colors.red);
  ColorScheme ThemeColor = const ColorScheme.dark();
  @override
  void initState() {
    super.initState();
    ThemeColor = widget.initialThemeColor;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashColor: Colors.transparent,
        colorScheme: ThemeColor,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateDatabaseHelper dbShiftHelper = DateDatabaseHelper(); //日付データベースのインスタンス
  UserDatabaseHelper dbUserHelper = UserDatabaseHelper();  //ユーザーデータベースのインスタンス

  List<StartToEnd> dbEventList = []; //データベースから取得したMapデータのリスト
  List<StartToEnd> textList = []; //ListView用テキストリスト
  String textData = ""; //ListTile用テキスト
  String idText = ""; //TextFieldのテキスト受取

  final imagePicker = ImagePicker(); //画像撮影クラス

  Map<String,dynamic> respo = {'IN':'??:??','OUT':'??:??','BRK':'??:??'};

  int currentIndex = 0;
  final List<Widget> pages = [
    const ShiftCalender(),
    const Setting(),
  ];

  void getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final _image = File(pickedFile.path);

      List<int> imageBytes = _image.readAsBytesSync();
      //base64にエンコード
      String base64Image = base64Encode(imageBytes);

      //サーバー側で設定してあるURLを選択
      Uri url = Uri.parse('https://29ba-116-94-19-118.ngrok-free.app/');

      //json形式を文字列に変換
      String body = json.encode({
        'post_img': base64Image,
        'crew_id': 'HC1855'
      });

      /// send to backend
      // サーバーにデータをPOST,予測画像をbase64に変換したものを格納したJSONで返ってくる
      try{
        Response response = await http.post(url, body: body).timeout(const Duration(seconds: 30));
        if (response.statusCode == 200){
          final dynamic data;
          if(response.body != '読み取りエラー'){
            data = jsonDecode(response.body);
          }
          else{
            data = response.body;
          }
          
          respo = data;
          setState(() {});
        }
      }catch(error){
        throw Exception(error);
        //setState(() {});
      }
    }
  }

  //アプリ起動時の設定
  @override
  void initState() {
    super.initState();
    dbShiftHelper.getAllData().then((times) {
      setState(() {
        dbEventList = times;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('開始${respo['IN']} 終了${respo['OUT']} 休憩${respo['BRK']}' ,
          style: const TextStyle(fontSize: 23),),
      ),

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      //メニューバー
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.exposure_minus_1), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          currentIndex = index;
          if (index == 2) {
            currentIndex = 1;
          }
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), //角の丸み
          ),
          onPressed: () {
            if (currentIndex != 0) {
              currentIndex = 0;
              setState(() {});
            } else {
              getImageFromCamera();
            }
          },
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: Colors.white, size: 35),
              Text('スキャン', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceivedData {
  final String? start_time;
  final String? end_time;
  final String? break_time;

  String? get getStartTime => start_time;
  String? get getEndTime => end_time;
  String? get getBreakTime => break_time;

  ReceivedData(
    {this.start_time,
    this.end_time,
    this.break_time});
  
  ReceivedData.fromJson(Map<String, dynamic> json)
      : start_time = json['IN'],
        end_time = json['OUT'],
        break_time = json['BREAK'];
}