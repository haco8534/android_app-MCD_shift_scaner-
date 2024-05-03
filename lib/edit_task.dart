import 'package:flutter/material.dart';

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
          Text(_selectedDay.toString()),
          Text(_index.toString())
        ],
      ),
    );
  } 

}