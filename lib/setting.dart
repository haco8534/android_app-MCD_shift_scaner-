import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Setting extends StatelessWidget{
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 50,
        title: const Text("編集"),

      ),

      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("ユーザー"),
            tiles: [
              SettingsTile(title: const Text("言語"))
            ] 
            ),
        ],
      ),
    );
  }
  
}