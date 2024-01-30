import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'shared_preferences_util.dart';
import 'dialog_utils.dart';
import 'todo_item.dart';
import 'edit_todo_dialog.dart';

class TodoListPage extends StatefulWidget {
  final SharedPreferencesUtil prefsUtil;
  const TodoListPage({super.key, required this.prefsUtil});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todoList = <TodoItem>[];
  final TextEditingController _textFieldController = TextEditingController();
  bool _showOnlyIncomplete = false;

  @override
  void initState() {
    super.initState();
    _loadTodoList();
    _loadShowOnlyIncomplete();
  }

  Future<void> _loadTodoList() async {
    List<TodoItem> todoList = await widget.prefsUtil.getTodoList(
        'todoList', (Map<String, dynamic> json) => TodoItem.fromJson(json));
    setState(() {
      _todoList.clear();
      _todoList.addAll(todoList);
    });
  }

  Future<void> _loadShowOnlyIncomplete() async {
    bool showOnlyIncomplete =
        await widget.prefsUtil.getBool('showOnlyIncomplete') ?? false;
    setState(() {
      _showOnlyIncomplete = showOnlyIncomplete;
    });
  }

  Future<void> _saveShowOnlyIncomplete(bool value) async {
    await widget.prefsUtil.setBool('showOnlyIncomplete', value);
  }

  Future<void> _saveTodoList() async {
    await widget.prefsUtil.saveTodoList(
      'todoList',
      _todoList,
      (TodoItem item) => item.toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Tarefas'),
        backgroundColor: Colors.lime,
        actions: [
          Switch(
            value: _showOnlyIncomplete,
            onChanged: (value) {
              setState(() {
                _showOnlyIncomplete = value;
                _saveShowOnlyIncomplete(value);
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: _getItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'add item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem(
    String title,
    DateTime selectedDate,
    TimeOfDay selectedTime,
  ) {
    setState(() {
      _todoList.add(TodoItem(
          title: title,
          isCompleted: false,
          date: selectedDate,
          time: selectedTime));
    });
    _textFieldController.clear();
    _saveTodoList();
  }

  Widget _buildTodoItem(TodoItem todoItem) {
    return Dismissible(
      key: Key(todoItem.title),
      onDismissed: (direction) {
        setState(() {
          _todoList.remove(todoItem);
        });
        _saveTodoList(); // Save the todo list when an item is dismissed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${todoItem.title} removido"),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              Text(
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                todoItem.title,
              ),
              const SizedBox(width: 8.0),
              const Icon(Icons.edit),
            ],
          ),
          trailing: Switch(
            value: todoItem.isCompleted,
            onChanged: (bool value) {
              setState(() {
                todoItem.isCompleted = value;
              });
              _saveTodoList(); // Save the todo list when an item is dismissed
            },
          ),
          onTap: () async {
            await EditTodoDialog.displayEditTaskDialog(
              context,
              todoItem,
              (updatedTodoItem) {
                setState(() {
                  // Atualize o item na lista
                  int index = _todoList.indexOf(todoItem);
                  _todoList[index] = updatedTodoItem;
                });
                _saveTodoList();
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    await DialogUtils.displayAddTaskDialog(context, _addTodoItem);
  }

  List<Widget> _getItems() {
    final List<Widget> todoWidgets = <Widget>[];
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    const TimeOfDayFormat timeFormatter = TimeOfDayFormat.HH_colon_mm;

    for (TodoItem todoItem in _todoList) {
      if (!_showOnlyIncomplete || !todoItem.isCompleted) {
        todoWidgets.add(_buildTodoItem(todoItem));
        todoWidgets.add(Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data: ${dateFormatter.format(todoItem.date.toLocal())}",
                style: const TextStyle(
                  fontSize: 19.0,
                  color: Color.fromARGB(255, 228, 112, 112),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Hora: ${formatTimeOfDay(todoItem.time, timeFormatter)}",
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 228, 112, 112),
                ),
              ),
            ],
          ),
        ));
      }
    }
    return todoWidgets;
  }

  String formatTimeOfDay(TimeOfDay timeOfDay, TimeOfDayFormat format) {
    if (format == TimeOfDayFormat.HH_colon_mm) {
      return '${timeOfDay.hour}:${timeOfDay.minute}';
    } else {
      return timeOfDay.format(context);
    }
  }
}
