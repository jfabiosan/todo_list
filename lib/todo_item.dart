import 'package:flutter/material.dart';

class TodoItem {
  String title;
  bool isCompleted;
  DateTime date;
  TimeOfDay time;

  TodoItem({
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      title: json['title'],
      isCompleted: json['isCompleted'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      ),
    );
  }
}
