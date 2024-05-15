// ignore_for_file: non_constant_identifier_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class StartToEnd {
  final int? id;
  final String? year;
  final String? month;
  final String? day;
  final String? start_time;
  final String? end_time;
  final String? break_time;

  int? get getId => id;
  String? get getYear => year;
  String? get getMonth => month;
  String? get getDay => day;
  String? get getStartTime => start_time;
  String? get getEndTime => end_time;
  String? get getBreakTime => break_time;

  StartToEnd({
    this.id,
    this.year,
    this.month,
    this.day,
    this.start_time,
    this.end_time,
    this.break_time}
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'start_time': start_time,
      'end_time': end_time,
      'break_time': break_time
    };
  }
}

class DatabaseHelper {

  //databaseが存在するか
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    //存在しない時新規作成
    _database = await initDatabase();
    return _database;
  }


  Future<Database> initDatabase() async {
    //databaseのパスを作成
    String path = join(await getDatabasesPath(), "my_database.db");
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE my_table(
            id INTEGER PRIMARY KEY,
            year TEXT,
            month TEXT,
            day TEXT,
            start_time TEXT,
            end_time TEXT,
            break_time TEXT
          )
        ''');
      },
    );
  }
  //全データの取得
  Future<List<StartToEnd>> getAllData() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps  = await db!.query('my_table');
    return List.generate(maps.length, (i) {
      return StartToEnd(
        id: maps[i]['id'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
        start_time: maps[i]['start_time'],
        end_time: maps[i]['end_time'],
        break_time: maps[i]['break_time'],
      );
    }
    );
  }
  //指定したidの取得
  Future<List<StartToEnd>> getDataById(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query('my_table', where: "id=?", whereArgs: [id],);
    return List.generate(maps.length, (i) {
      return StartToEnd(
        id: maps[i]['id'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
        start_time: maps[i]['start_time'],
        end_time: maps[i]['end_time'],
        break_time: maps[i]['break_time'],
      );
    });
  }

  //挿入
  Future<void> insertData(StartToEnd data) async {
    final Database? db = await database;
    await db!.insert('my_table', data.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //更新
  Future<int> updateData(int id, Map<String, dynamic> data)  async {
    final Database? db = await database;
    return await db!.update('my_table', data, where: 'id = ?', whereArgs: [id]);
  }
  //削除
  Future<int> deleteData(int id) async {
    final Database? db = await database;
    return await db!.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }
}

