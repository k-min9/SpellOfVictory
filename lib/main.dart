import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/page/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hive 초기화
  await Hive.initFlutter();
  // Hive.registerAdapter(CategoryModelAdapter());
  // Hive.registerAdapter(TextModelAdapter());
  await HiveBoxes.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
