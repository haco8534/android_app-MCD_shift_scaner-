import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

class EditTask extends StatelessWidget {
  const EditTask(this._selectedDay,this._index, {super.key});

  final int? _index;
  final DateTime _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: const Text("編集"),

      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
              color: Colors.white
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("開始日時",style:TextStyle(fontSize: 25),textAlign: TextAlign.left,),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        side: const BorderSide(color: Colors.grey,width: 1,)
                      ),
                      onPressed: (){
                        DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          currentTime: _selectedDay,
                          minTime: DateTime(2023, 1, 1),
                          maxTime: DateTime(2030, 12, 31),
                          onConfirm: (date) {
                            
                          },
                          locale: LocaleType.jp
                        );
                      },
                      child: Text(
                        DateFormat("yyyy/M/d").format(_selectedDay),
                        style: const TextStyle(fontSize: 25)
                        ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        side: const BorderSide(color: Colors.grey,width: 1,)
                      ),
                      onPressed: (){
                        DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          currentTime: _selectedDay,
                          minTime: DateTime(2023, 1, 1),
                          maxTime: DateTime(2030, 12, 31),
                          onConfirm: (date) {
                            
                          },
                          locale: LocaleType.jp
                        );
                      },
                      child: Text(
                        DateFormat("hh:mm").format(_selectedDay),
                        style: const TextStyle(fontSize: 25)
                        ),
                    ),
                  ]
                )
              ],
            ),
          )

        ],
      ),
    );
  } 

}