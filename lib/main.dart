import 'package:flutter/material.dart';
import 'todo_list_page.dart';
import 'shared_preferences_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize a classe SharedPreferencesUtil
  SharedPreferencesUtil prefsUtil = SharedPreferencesUtil();
  await prefsUtil.init();

  runApp(MyApp(prefsUtil: prefsUtil));
}

class MyApp extends StatelessWidget {
  final SharedPreferencesUtil prefsUtil;

  const MyApp({super.key, required this.prefsUtil});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(prefsUtil: prefsUtil),
    );
  }
}
