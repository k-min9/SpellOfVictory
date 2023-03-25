import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';

class MainDrawer extends StatelessWidget {

  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('설정')
                    ],
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Hive 초기화'),
            onTap: () async {
              // Box째 싹 초기화
              // await Hive.deleteFromDisk();
              // await HiveBoxes.init();
              
              // 내용물만 초기화
              HiveBoxes.settings.clear();
              HiveBoxes.voices.clear();
              HiveBoxes.choices.clear();
              HiveBoxes.categories.clear();
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('초기값 추가'),
            onTap: () async {
              await HiveBoxes.setInitData();
            },
          ),
          ListTile(
            leading: Icon(Icons.play_circle),
            title: Text('튜토리얼 시작'),
            onTap: () {
              // TODO: Implement tutorial screen.
            },
          ),
        ],
      ),
    );
  }
}
