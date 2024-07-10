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
            title: const Text("テーマ"),
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
                title: const Text("パープル",style: TextStyle(fontSize:20),),
                leading: Radio(
                  value: 4,
                  groupValue: colorGroup,
                  onChanged: (value) async{
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      colorGroup = value;
                      prefs.setString('ThemeColor','パープル');
                      prefs.setInt('RadioIndex',3);
                    },);
                  },
                ),
              ),
              ListTile(
                title: const Text("ダーク",style: TextStyle(fontSize:20),),
                leading: Radio(
                  value: 5,
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                child: const Text("適用",style: TextStyle(color: Colors.white)),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ),
          ),
          const Text("※テーマはアプリ再起動時に適用されます。",style: TextStyle(fontSize: 15)),
        ]),
    );
  }
}
