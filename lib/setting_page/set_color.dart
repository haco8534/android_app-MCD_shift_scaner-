import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetColor extends StatefulWidget {
  const SetColor({super.key});

  @override
  State<SetColor> createState() => _SetColor();
}

class _SetColor extends State<SetColor> {

  int? colorGroup;

  void loadRadioIndex() async{
      final prefs = await SharedPreferences.getInstance();
      colorGroup = prefs.getInt("RadioIndex") ?? 0;
    }


  @override
  Widget build(BuildContext context) {
  
    loadRadioIndex();

    return Scaffold(
      appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            toolbarHeight: 50,
            title: const Text("編集"),
          ),
      body: Column(
        children:[
          SizedBox(
            child: Column(
            children: [
              ListTile(
                title: const Text("ブルー",style: TextStyle(fontSize:20),),
                leading: Radio(
                  value: 0,
                  groupValue: colorGroup,
                  onChanged: (value) async{
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      colorGroup = value;
                      prefs.setString('ThemeColor','ブルー');
                      prefs.setInt('RadioIndex',0);
                    },);
                  },
                ),
              ),
              ListTile(
                title: const Text("レッド",style: TextStyle(fontSize:20),),
                leading: Radio(
                  value: 1,
                  groupValue: colorGroup,
                  onChanged: (value) async{
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      colorGroup = value;
                      prefs.setString('ThemeColor','レッド');
                      prefs.setInt('RadioIndex',1);
                    },);
                  },
                ),
              ),
              ListTile(
                title: const Text("グリーン",style: TextStyle(fontSize:20),),
                leading: Radio(
                  value: 2,
                  groupValue: colorGroup,
                  onChanged: (value) async{
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      colorGroup = value;
                      prefs.setString('ThemeColor','グリーン');
                      prefs.setInt('RadioIndex',2);
                    },);
                  },
                ),
              ),
              ListTile(
                title: const Text("ピンク",style: TextStyle(fontSize:20),),
                leading: Radio(
                  value: 3,
                  groupValue: colorGroup,
                  onChanged: (value) async{
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      colorGroup = value;
                      prefs.setString('ThemeColor','ピンク');
                      prefs.setInt('RadioIndex',3);
                    },);
                  },
                ),
              ),
              ListTile(
                title: const Text("ダーク",style: TextStyle(fontSize:20),),
                leading: Radio(
                  value: 4,
                  groupValue: colorGroup,
                  onChanged: (value) async{
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      colorGroup = value;
                      prefs.setString('ThemeColor','ダーク');
                      prefs.setInt('RadioIndex',4);
                    },);
                  },
                ),
              ),
            ],
        ),
        ),
          Container(
            width: double.infinity,
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                ElevatedButton(
                  child: const Text("適用"),
                  onPressed: (){
                    Navigator.pop(context);
                  },)
              ],
            ),
          ),
        ]),
    );
  }
}
