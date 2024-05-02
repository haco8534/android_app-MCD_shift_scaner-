import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MCDシフトAIスキャナー(仮)'),
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

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _selectedEvents = [];

  final sampleEvents = {
  DateTime.utc(2024, 5, 3): ['firstEvent', 'secodnEvent'],
  DateTime.utc(2024, 5, 5): ['thirdEvent', 'fourthEvent']
  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
        actions:const <Widget>[
          Icon(Icons.add),
          Icon(Icons.share),
        ]
      ),

      body: Column(
        children: <Widget>[ 
          SizedBox(
          height: 450, //カレンダーの高さ
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,

              headerStyle: const HeaderStyle(
                formatButtonVisible: false, //フォーマットボタンを非表示
                titleCentered: true, //日付を中央に配置
              ),

              locale: 'ja_JP',
              selectedDayPredicate: (day){
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (date) { //イベントを表示
                return sampleEvents[date] ?? [];
              },
              shouldFillViewport: true, //大きさの変更を許可

              onDaySelected: (selectedDay,focusedDay){
                setState((){
                  _selectedDay = selectedDay; //選択された日付
                  _focusedDay = focusedDay; //強調表示する日付
                  _selectedEvents = sampleEvents[selectedDay] ?? [];
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color:Colors.black, width: 1),
              color: Colors.blueGrey[50],
              ),
            child: Center(
              child: Text(
                DateFormat("yyyy年M月d日(E)","ja").format(_selectedDay ?? DateTime.now()), //選択された日付を表示
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              
            ),
          ),
        ],
      ),
    
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム',),
            BottomNavigationBarItem(icon: Icon(Icons.exposure_minus_1), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '設定'),
          ],
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,  
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), //角の丸み
          ),
          onPressed: (){},
          tooltip: 'Increment',
          backgroundColor: Colors.green,
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
