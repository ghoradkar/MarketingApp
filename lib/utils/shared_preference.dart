import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    final str = json.encode(value);
    debugPrint("save str = $str");
    prefs.setString(key, str);

    debugPrint("saved val = $str");
  }
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final strRes = prefs.getString(key);
    debugPrint("User data fetched = $strRes");
    if (strRes != null) {
      final jsonRes = json.decode(strRes);
      //debugPrint("read json = ${jsonRes}");
      return jsonRes;
    }
  }
  saveUserData(String key, value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, jsonEncode(value));
    debugPrint("UserData: $value");
  }

  Future<void> clearSaveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }


  Future<void> write(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(value);
    prefs.setString(key, jsonString);
  }

  Future<String?> readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }


  Future<bool?> readBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  removeData(String key)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

}