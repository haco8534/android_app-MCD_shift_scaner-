import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nholiday_jp/nholiday_jp.dart';

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
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;

class _MyHomePageState extends State<MyHomePage> {

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

      body: Center(
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          locale: 'ja_JP',
          selectedDayPredicate: (day){
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay,focusedDay){
            setState((){
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
        ),
      ),
    
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'お知らせ'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          ],
        ),
        
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      
    );
  }
}
