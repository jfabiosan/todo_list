import 'package:flutter/material.dart';
import 'package:todo/date_picker.dart';
import 'package:todo/todo_item.dart';
import 'package:todo/time_picker.dart';

class EditTodoDialog {
  static Future<void> displayEditTaskDialog(BuildContext context,
      TodoItem todoItem, Function(TodoItem) editTaskCallback) async {
    DateTime selectedDate = todoItem.date;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(todoItem.date);

    String updatedTask = todoItem.title;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                    const InputDecoration(hintText: "Editar a tarefa aqui"),
                onChanged: (value) {
                  updatedTask = value;
                },
                controller: TextEditingController(text: todoItem.title),
              ),
              DatePickerWidget(
                initialDate: todoItem.date,
                onDateTimeSelected: (date) {
                  selectedDate = date;
                },
              ),
              TimePickerWidget(
                initialTime: todoItem.time,
                onTimeSelected: (time) {
                  selectedTime = time;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Salvar"),
              onPressed: () {
                if (updatedTask.isNotEmpty) {
                  Navigator.of(context).pop();
                  TodoItem updatedTodoItem = TodoItem(
                    title: updatedTask,
                    isCompleted: todoItem.isCompleted,
                    date: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute),
                    time: selectedTime,
                  );
                  editTaskCallback(updatedTodoItem);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor, preencha o campo de tarefa."),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
