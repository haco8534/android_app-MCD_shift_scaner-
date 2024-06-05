import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:mcd_app/models/user_model.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  UserDatabaseHelper dbUserHelper = UserDatabaseHelper(); //ユーザーデータベースのインスタンス
  List<UserData>? data; //データベースの全データ
  UserData? record; //データベースの1番目のレコード

  String? name; //名前
  int? wage; //時給
  String? theme;//テーマカラー
/*
  @override
  void initState(){
    super.initState();
    dbUserHelper.insertData(UserData(id: 1,name: "undefined",wage: 9999,theme_color: "blue"));
    Future(() async{
      data = await dbUserHelper.getAllData();
    });

    record = data![0];
    
    name = record!.getName;
    wage = record!.getWage;
    theme = record!.getThemeColor;
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(title: const Text("個人設定"), tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.person),
              title: const Text("クルーID"),
              value: const Text("HC1855"),
            ),
            SettingsTile.navigation(
                leading: const Icon(Icons.currency_yen),
                title: const Text("時給"),
                value: const Text("1000円")),
            SettingsTile.navigation(
                leading: const Icon(Icons.color_lens),
                title: const Text("テーマ"),
                value: const Text("未定")),
          ]),
          SettingsSection(title: const Text("通知"), tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.notifications),
              title: const Text("通知タイミング"),
            ),
          ]),
          SettingsSection(title: const Text("その他"), tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.mail),
              title: const Text("お問い合わせ"),
            ),
            SettingsTile(
              leading: const Icon(Icons.info),
              title: const Text("バージョン"),
              trailing: const Text("Development Verstion"),
            ),
          ]),
        ],
      ),
    );
  }
}
