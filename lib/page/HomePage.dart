import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  // List<Widget> _pages = [HomePage(), RegisterPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TTS App'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('categories').listenable(),
        builder: (context, Box<dynamic> categoriesBox, _) {
          if (categoriesBox.values.isEmpty) {
            return Center(
              child: Text('등록한 주문이 없습니다.'),
            );
          }
          return ListView.builder(
            itemCount: categoriesBox.length,
            itemBuilder: (context, index) {
              final CategoryModel category =
              categoriesBox.getAt(index) as CategoryModel;
              return ExpansionTile(
                title: Text(category.name),
                children: category.texts
                    .map((text) => ListTile(
                  title: Text(text),
                  onTap: () {},
                ))
                    .toList(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        onTap: (int index) {
          // TODO: Navigate to the selected page
        },
      ),
    );
  }
}