import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'database/database_helper.dart';  // Make sure this is the correct path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;  // Initialize the database
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
