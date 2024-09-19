// ignore_for_file: non_constant_identifier_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserData {
  final int? id;
  final String? name;
  final int? wage;
  final String? theme_color;

  int? get getId => id;
  String? get getName => name;
  int? get getWage => wage;
  String? get getThemeColor => theme_color;

  UserData({this.id, this.name, this.wage, this.theme_color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'wage': wage,
      'theme_color': theme_color,
    };
  }
}

class UserDatabaseHelper {
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
    String path = join(await getDatabasesPath(), "user_info.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user_info(
            id INTEGER PRIMARY KEY,
            name TEXT,
            wage INTEGER,
            theme_color TEXT
          )
        ''');
      },
    );
  }

  //全データの取得
  Future<List<UserData>> getAllData() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('user_info');
    return List.generate(maps.length, (i) {
      return UserData(
        id: maps[i]['id'],
        name: maps[i]['name'],
        wage: maps[i]['wage'],
        theme_color: maps[i]['theme_color'],
      );
    });
  }

  //指定したidの取得
  Future<List<UserData>> getDataById(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query(
      'user_info',
      where: "id=?",
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return UserData(
        id: maps[i]['id'],
        name: maps[i]['name'],
        wage: maps[i]['wage'],
        theme_color: maps[i]['theme_color'],
      );
    });
  }

  //挿入
  Future<void> insertData(UserData data) async {
    final Database? db = await database;
    await db!.insert('user_info', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //更新
  Future<int> updateData(int id, Map<String, dynamic> data) async {
    final Database? db = await database;
    return await db!
        .update('user_info', data, where: 'id = ?', whereArgs: [id]);
  }

  //削除
  Future<int> deleteData(int id) async {
    final Database? db = await database;
    return await db!.delete('user_info', where: 'id = ?', whereArgs: [id]);
  }
}
