import 'package:mcd_app/models/date_model.dart';

//データベースに同じ日のシフトが存在するか調べる
Future<bool> confirmExistShift(String month, String day) async{
  bool isExist = true;

  DateDatabaseHelper dbShiftHelper = DateDatabaseHelper(); //データベースのインスタンス
  
  return isExist;
}