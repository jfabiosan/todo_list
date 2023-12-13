import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todoList = <TodoItem>[];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        backgroundColor: Colors.lime,
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

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(TodoItem(title: title, isCompleted: false));
    });
    _textFieldController.clear();
  }

  Widget _buildTodoItem(TodoItem todoItem) {
    return Dismissible(
      key: Key(todoItem.title),
      onDismissed: (direction) {
        setState(() {
          _todoList.remove(todoItem);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${todoItem.title}removido"),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(todoItem.title),
        trailing: Switch(
            value: todoItem.isCompleted,
            onChanged: (bool value) {
              setState(() {
                todoItem.isCompleted = value;
              });
            }),
      ),
    );
  }

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Adicione a tarefa na lista"),
            content: TextField(
              controller: _textFieldController,
              decoration:
                  const InputDecoration(hintText: "Digite a tarefa aqui"),
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
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> todoWidgets = <Widget>[];
    for (TodoItem todoItem in _todoList) {
      todoWidgets.add(_buildTodoItem(todoItem));
    }
    return todoWidgets;
  }
}

class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({required this.title, required this.isCompleted});
}
