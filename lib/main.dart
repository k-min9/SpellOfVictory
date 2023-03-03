import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/page/HomePage.dart';
import 'package:spell_of_victory/page/RegisterPage.dart';
import 'package:spell_of_victory/page/SettingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hive 초기화
  await Hive.initFlutter();
  await HiveBoxes.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<Widget> _pages = [HomePage(), RegisterPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('TTS App'),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Register',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      )
    );
  }
}
