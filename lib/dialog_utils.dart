import 'package:flutter/material.dart';
import 'package:todo/date_picker.dart';
import 'package:todo/time_picker.dart'; // Importe o TimePickerWidget

class DialogUtils {
  static Future<void> displayAddTaskDialog(BuildContext context,
      Function(String, DateTime, TimeOfDay) addTaskCallback) async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    String newTask = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adicione sua tarefa na lista"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration:
                      const InputDecoration(hintText: "Digite a tarefa aqui"),
                  onChanged: (value) {
                    newTask = value;
                  },
                ),
                DatePickerWidget(
                  onDateTimeSelected: (date) {
                    selectedDate = date;
                  },
                ),
                TimePickerWidget(
                  onTimeSelected: (time) {
                    selectedTime = time;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Adicionar"),
              onPressed: () {
                if (newTask.isNotEmpty) {
                  Navigator.of(context).pop();
                  addTaskCallback(newTask, selectedDate, selectedTime);
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
