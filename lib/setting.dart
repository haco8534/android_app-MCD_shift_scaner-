import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'setting_page/set_color.dart';
import 'setting_page/set_crew_id.dart';
import 'setting_page/set_wage.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  String? name; //名前
  String? wage; //時給
  String theme = "ブルー";//テーマカラー

  String? inputName;  //入力されたクルーID
  String? inputWage;  //入力された時給

  Future<void> ititialSetting() async{
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('CrewId');
    wage = prefs.getString('Wage');
    theme = prefs.getString('ThemeColor')!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ititialSetting();
  }

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
              value: Text(name ?? "???"),
              onPressed: (context){
                showDialog(
                  context: context,
                  builder: (context){
                    return SingleChildScrollView(
                      reverse: true,
                      child: CrewIdWidget().dialogWidget(context),
                    );
                  } 
                );
              },
            ),
            SettingsTile.navigation(
                leading: const Icon(Icons.currency_yen),
                title: const Text("時給"),
                value: Text('${wage ?? "???"}円'),
                onPressed: (context){
                showDialog(
                  context: context,
                  builder: (context){
                    return SingleChildScrollView(
                      reverse: true,
                      child: WageWidget().dialogWidget(context),
                    );
                  } 
                );
                },
            ),
            SettingsTile.navigation(
                leading: const Icon(Icons.color_lens),
                title: const Text("テーマ"),
                value: Text(theme),
                onPressed: (context){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => (const SetColor()))
                  );
                },
                ),
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
