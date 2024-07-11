import 'package:mcd_app/models/date_model.dart';

//データベースに同じ日のシフトが存在するか調べる
Future<bool> isExsistTheShift(String year,String month, String day) async{
  String dbYear;
  String dbMonth;
  String dbDay;

  DateDatabaseHelper dbShiftHelper = DateDatabaseHelper(); //データベースのインスタンス
  List<StartToEnd> dbEventList = []; //データベースから取得したMapデータのリスト

  dbEventList = await dbShiftHelper.getAllData(); //データベースからシフトを取得
  
  for (StartToEnd event in dbEventList) {
    dbYear = event.getYear!; //eventの年
    dbMonth = event.getMonth!; //evetの月
    dbDay = event.getDay!; //eventの日

    if(year == dbYear && month == dbMonth && day == dbDay){ //年月日が一致
      return true;
    }
  }

  return false;
}