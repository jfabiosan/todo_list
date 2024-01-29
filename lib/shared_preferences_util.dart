import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesUtil {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<T>> getTodoList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    List<String>? todoList = _prefs.getStringList(key);
    if (todoList == null) {
      return <T>[];
    }

    return todoList.map((String item) {
      Map<String, dynamic> todoMap =
          Map<String, dynamic>.from(json.decode(item));
      return fromJson(todoMap);
    }).toList();
  }

  Future<void> saveTodoList<T>(String key, List<T> todoList,
      Map<String, dynamic> Function(T) toJson) async {
    List<String> todoListString =
        todoList.map((T item) => json.encode(toJson(item))).toList();
    await _prefs.setStringList(key, todoListString);
  }
}
