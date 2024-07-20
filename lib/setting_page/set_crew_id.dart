import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrewIdWidget {
  Widget dialogWidget(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final MediaQueryData data = MediaQuery.of(context);

    String? inputText;

    Future<void> setNewData(String value) async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("CrewId", value);
    }

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 5,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("クルーID", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: MediaQuery(
                          data: data.copyWith(
                              // ignore: deprecated_member_use
                              textScaler: TextScaler.linear(min(1.5, data.textScaleFactor))
                                ),
                          child: TextFormField(
                              onChanged: (value) {
                                inputText = value;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 5,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  hintText: "AB1234"),
                              keyboardType: TextInputType.text),
                        ),
                      ),
                    ],
                  ),
                )
              ),
              const Text("アルファベットは大文字、数字は半角で入力してください",style: TextStyle(fontSize: 9)),
              const Divider(
                color: Colors.grey,
                height: 10,
              ),
            ],
          ),
          SizedBox(height: deviceHeight / 20),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 5, bottom: 30),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white38,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
                        child: const Text("戻る"),
                      ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 5, right: 20, bottom: 30),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async{
                        setNewData(inputText ?? "????");
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
                        child: const Text("変更する"),
                      ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

