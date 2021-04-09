import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/models/logs.dart';
import 'package:flutterapp/resources/local_db/interface/log_interface.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveMethods implements LogInterface {
  String hive_box = "";

  @override
  openDb(dbName) => (hive_box = dbName);

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(Log log) async {
    var box = await Hive.openBox(hive_box);

    var logMap = log.toMap(log);

    // box.put("custom_key", logMap);
    int idOfInput = await box.add(logMap);

    print("Log added with id ${idOfInput.toString()} in Hive db");

    close();

    return idOfInput;
  }

  updateLogs(int i, Log newLog) async {
    var box = await Hive.openBox(hive_box);

    var newLogMap = newLog.toMap(newLog);

    box.putAt(i, newLogMap);

    close();
  }

  @override
  Future<List<Log>> getLogs() async {
    var box = await Hive.openBox(hive_box);

    List<Log> logList = [];

    for (int i = 0; i < box.length; i++) {
      var logMap = box.getAt(i);

      logList.add(Log.fromMap(logMap));
    }
    return logList;
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hive_box);

    await box.deleteAt(logId);
    // await box.delete(logId);
  }

  @override
  close() => Hive.close();
}