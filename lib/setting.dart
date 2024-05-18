import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(title: const Text("個人設定"), tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.person),
              title: const Text("名前"),
              value: const Text("池辺 志槻"),
            ),
            SettingsTile.navigation(
                leading: const Icon(Icons.currency_yen),
                title: const Text("時給"),
                value: const Text("1000円")),
            SettingsTile.navigation(
                leading: const Icon(Icons.color_lens),
                title: const Text("テーマ"),
                value: const Text("ブルー")),
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
