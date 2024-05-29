// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import '../models/date_model.dart';

class EditTask extends StatefulWidget {
  const EditTask(this._selectedDay, this._selectedData, {super.key});

  final DateTime _selectedDay;
  final StartToEnd? _selectedData;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
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
    startTime = widget._selectedData!.getStartTime!;
    endTime = widget._selectedData!.getEndTime!;
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
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
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
                      border: Border.all(color: Colors.grey),
                      color: Colors.white),
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
                                  side: const BorderSide(
                                color: Colors.grey,
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
                                  side: const BorderSide(
                                color: Colors.grey,
                                width: 1,
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
                                  side: const BorderSide(
                                color: Colors.grey,
                                width: 1,
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
                                  side: const BorderSide(
                                color: Colors.grey,
                                width: 1,
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
                        int id = widget._selectedData!.getId!;
                        //データべース更新
                        dbShiftHelper.updateData(id, {"year": DateFormat("yyyy").format(thisDate_date!)});
                        dbShiftHelper.updateData(id,{"month": DateFormat("M").format(thisDate_date!)});
                        dbShiftHelper.updateData(id,{"day": DateFormat("dd").format(thisDate_date!)});
                        dbShiftHelper.updateData(id, {"start_time": startTime});
                        dbShiftHelper.updateData(id, {"end_time": endTime});
                        Navigator.pop(context, dbShiftHelper.getAllData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text("完了")),
                ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10,bottom: 10),
                  child: SizedBox(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                        onPressed: () {
                          dbShiftHelper.deleteData(widget._selectedData!.getId!);
                          Navigator.pop(context, dbShiftHelper.getAllData());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: const Text("削除")),
                  ),
                ),
              ],
            ),
          )),
      ),
    );
  }
}
