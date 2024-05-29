import 'package:mcd_app/models/user_model.dart';
import 'package:flutter/material.dart';

Future<ColorScheme> setColor()async{
  //データベースから取得した色
  String colorName;
  //カラースキーム
  ColorScheme? colorScheme;
  //データベースのインスタンス
  UserDatabaseHelper dbUserHelper = UserDatabaseHelper();
  //データベースの全データ
  List<UserData> data;

  data = await dbUserHelper.getAllData();
  colorName = data[0].getThemeColor!;

  if(colorName == "blue"){
    colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  }

  return colorScheme!;
}