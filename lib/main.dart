// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;


import 'models/date_model.dart';
import 'edit_task.dart';

Future<void> main() async{
  await initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  DatabaseHelper dbHelper = DatabaseHelper(); //データベースのインスタンス
  List<StartToEnd> dbEventList = [];  //データベースから取得したMapデータのリスト
  List<StartToEnd> textList = []; //ListView用テキストリスト
  String textData = ""; //ListTile用テキスト
  String idText = ""; //TextFieldのテキスト受取

  List<String> _selectedEvents = []; //選択日付のイベント

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime,List<String>> eventMap = {}; //dbEventListをイベント形式に変換したMap
  StartToEnd? _selectedData; //選択された日付に対応するDBレコード

  final imagePicker = ImagePicker(); //画像撮影クラス  

  int currentIndex = 1;

  Future getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final _image = File(pickedFile.path);

      List<int> imageBytes = _image.readAsBytesSync();
      //base64にエンコード
      String base64Image = base64Encode(imageBytes);

      //サーバー側で設定してあるURLを選択
      Uri url = Uri.parse('http://192.168.0.25:5000/receive');
      
      //json形式を文字列に変換
      String body = json.encode({
        'post_img': base64Image,
      });

      /// send to backend
      // サーバーにデータをPOST,予測画像をbase64に変換したものを格納したJSONで返ってくる
      Response response = await http.post(url, body: body);
      return response.body;
    }
  }

  //アプリ起動時の設定
  @override
  void initState(){
    super.initState();

    dbHelper.getAllData().then((times) {
      setState(() {
        dbEventList = times;
      });
    });
  }

  void setSelectedId(DateTime? selectedDay)async{
    List<int> _seledtedId = [];
    List<StartToEnd> _selectedDataList;

    String? dbDayText;
    //データベース年月日の格納
    DateTime? dbDayDateTime;

    for (StartToEnd shift in dbEventList){
      //dbDatDateTimeにデータベースの日付を格納
      dbDayText = "${shift.getYear!}/${shift.getMonth!}/${shift.getDay!}";
      dbDayDateTime = DateFormat("yyyy/M/d").parseStrict(dbDayText);

      if(DateFormat("yyyy/MM/dd").format(_selectedDay!) == DateFormat("yyyy/MM/dd").format(dbDayDateTime)){
        _seledtedId.add(shift.getId!);
      }
    }
    //ある日付のidを取得した時
    if(_seledtedId.isNotEmpty){
      //その日付のデータリスト取得
      _selectedDataList =  await dbHelper.getDataById(_seledtedId[0]);
      //1つ目のデータを取得 <=将来的には押したボタンを判定する
      _selectedData = _selectedDataList[0];
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Column(
        children:[
          /*Row( //データベース編集
            children: [
              TextButton(
                onPressed: ()async{
                  dbHelper.insertData(
                    StartToEnd(id: int.parse(idText),year: "2024",month: "5",day: "15",start_time: "12:00",end_time: "23:00"));
                },
                child: const Text("db挿入"),
              ),
              TextButton(
                onPressed: (()async{
                  dbHelper.deleteData(int.parse(idText));
                }),
                child: const Text("db削除"),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  onChanged: (value){
                    idText = value;
                  },
                )
              ),
            ],
          ),*/
          SizedBox( //カレンダー
            width: double.infinity,
            height: 300,
            child:  TableCalendar( 
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,

              locale: 'ja_JP',
              shouldFillViewport: true, //大きさの変更を許可

              headerStyle: const HeaderStyle(
                formatButtonVisible: false, //フォーマットボタンを非表示
                titleCentered: true, //日付を中央に配置
                titleTextStyle: TextStyle(
                  fontSize: 20,
                ),
                headerPadding: EdgeInsets.all(1)
              ),

              
              selectedDayPredicate: (day){
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay,focusedDay){
                setState((){
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = eventMap[selectedDay] ?? [];
                  setSelectedId(_selectedDay);
                });
              },
              eventLoader: (date) { //イベントを表示

                String? thisDay;
                DateTime utcThisDay;
                DateTime dateFormat;

                eventMap.clear();

                for (StartToEnd shift in dbEventList){
                  thisDay = "${shift.getYear!}/${shift.getMonth!}/${shift.getDay!}";
                  dateFormat = DateFormat("yyyy/M/d").parseStrict(thisDay);
                  utcThisDay = DateTime.utc(dateFormat.year,dateFormat.month,dateFormat.day);
                  eventMap[utcThisDay] = ['${shift.getStartTime}~${shift.getEndTime}'];
                }

                return eventMap[date] ?? [];
              },
            ),
          ),
          /*Expanded( //データベース内容表示
            child: ListView.builder(
                itemCount: dbEventList.length,
                itemBuilder: (context, index) {
                    for (StartToEnd myData in dbEventList) {
                      textList.add(myData);
                    }
                    textData = "id:${textList[index].getId.toString()}" 
                    " year:${textList[index].getYear}"
                    " month:${textList[index].getMonth}"
                    " day:${textList[index].getDay}"
                    "  ${textList[index].getStartTime}"
                    "~${textList[index].getEndTime}";

                    return Card(
                      child: ListTile(
                        title: Text(textData.toString()),
                      ),
                    );
                },
            ),
          ),
        */  
          Container( //日付表示
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color:Colors.black, width: 1),
              color: Colors.blueGrey[50],
              ),
            child: Center(
              child: Text(
                DateFormat("yyyy年M月d日(E)","ja").format(_selectedDay ?? DateTime.now()), //選択された日付を表示
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Expanded(//イベントリスト
            child: SizedBox(
              child: ListView.builder(
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  final event = _selectedEvents[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: Text(event,style: const TextStyle(fontSize: 20),),
                      onTap: ()async{
                        dbEventList = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditTask(_selectedDay ?? DateTime.now(),_selectedData)),
                        );
                        setState(() {});
                      },
                      ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      //メニューバー
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム',),
              BottomNavigationBarItem(icon: Icon(Icons.exposure_minus_1), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
            ],
          onTap: (index){
            setState(() {
              currentIndex = index;
            });
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
            onPressed: (){getImageFromCamera();},
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt,color: Colors.white,size: 35),
                Text('スキャン',style:TextStyle(color: Colors.white)),
              ],
            ),
            ),
        ),
    );
  }
}
