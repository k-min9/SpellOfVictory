import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
              await Hive.initFlutter();
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('초기값 추가'),
            onTap: () {
              final box = Hive.box('myBox');
              box.put('key', 'value');
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
