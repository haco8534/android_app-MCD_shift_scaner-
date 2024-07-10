// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import '../models/date_model.dart';

class AddTask extends StatefulWidget {
  const AddTask(this._selectedDay, {super.key});

  final DateTime _selectedDay;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //データベースのインスタンス
  final DateDatabaseHelper dbShiftHelper = DateDatabaseHelper();

  String thisDate_str = "";
  String startTime = "";
  String endTime = "";
  DateTime? thisDate_date;

  @override
  void initState() {
    super.initState();
    thisDate_str = DateFormat("yyyy/M/d").format(widget._selectedDay);
    thisDate_date = DateFormat("yyyy/M/d").parseStrict(thisDate_str);
    startTime = "12:00";
    endTime = "18:00";
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(dbShiftHelper.getAllData());
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            toolbarHeight: 50,
            title: const Text("編集"),
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 400,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  side:  BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              )),
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    currentTime: thisDate_date,
                                    minTime: DateTime(2023, 1, 1),
                                    maxTime: DateTime(2030, 12, 31),
                                    onConfirm: (date) {
                                  thisDate_str =
                                      DateFormat("yyyy/M/d").format(date);
                                  thisDate_date = DateFormat("yyyy/M/d")
                                      .parseStrict(thisDate_str);
                                  setState(() {});
                                }, locale: LocaleType.jp);
                              },
                              child: Text(thisDate_str,
                                  style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.alarm_on,
                            size: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.primary,
                              )),
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    showTitleActions: true,
                                    currentTime: DateFormat("HH:mm")
                                        .parseStrict(startTime),
                                    showSecondsColumn: false,
                                    onConfirm: (date) {
                                  setState(() {
                                    startTime =
                                        DateFormat("HH:mm").format(date);
                                  });
                                }, locale: LocaleType.jp);
                              },
                              child: Text(startTime,
                                  style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_double_arrow_right,
                            size: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  side:  BorderSide(
                                    width: 1,
                                    color: Theme.of(context).colorScheme.primary,
                              )),
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    showTitleActions: true,
                                    currentTime: DateFormat("HH:mm")
                                        .parseStrict(endTime),
                                    showSecondsColumn: false,
                                    onConfirm: (date) {
                                  endTime = DateFormat("HH:mm").format(date);
                                  setState(() {});
                                }, locale: LocaleType.jp);
                              },
                              child: Text(endTime,
                                  style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.hotel,
                            size: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  side: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    showTitleActions: true,
                                    currentTime: widget._selectedDay,
                                    showSecondsColumn: false,
                                    onConfirm: (date) {},
                                    locale: LocaleType.jp);
                              },
                              child: const Text("00:00",
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ],
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
                    onPressed: () {
                      dbShiftHelper.insertData(
                        StartToEnd(
                          year: DateFormat("yyyy").format(thisDate_date!),
                          month: DateFormat("M").format(thisDate_date!),
                          day: DateFormat("d").format(thisDate_date!),
                          start_time: startTime,
                          end_time: endTime,
                          break_time: "0",
                        ),
                      );
                      Navigator.pop(context, dbShiftHelper.getAllData());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    child:  const Text("完了",style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
