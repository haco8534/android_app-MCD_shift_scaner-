import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ColorScheme> setColor() async{
  //データベースから取得した色
  String colorName;
  //カラースキーム
  ColorScheme? colorScheme;

  final prefs = await SharedPreferences.getInstance();
  colorName = prefs.getString('ThemeColor')!;

  if(colorName == "レッド"){
    colorScheme = ColorScheme.fromSeed(seedColor: Colors.red);
  }
  else if(colorName == "ブルー"){
    colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  }
  else if(colorName == "グリーン"){
    colorScheme = ColorScheme.fromSeed(seedColor: Colors.green);
  }
  else if(colorName == "ピンク"){
    colorScheme = ColorScheme.fromSeed(seedColor: Colors.pink);
  }
  else if(colorName == "ダーク"){
    colorScheme = ColorScheme.fromSeed(seedColor: Colors.black);
  }

  return colorScheme!;
}