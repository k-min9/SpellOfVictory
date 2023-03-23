import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/VoiceModel.dart';
import 'package:spell_of_victory/page/VoiceDetailPage.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<VoiceModel>('voice').listenable(),
        builder: (BuildContext context, Box<VoiceModel> box, Widget? child) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('등록한 음성이 없습니다.'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (BuildContext context, int index) {
              VoiceModel voice = box.getAt(index) as VoiceModel;
              return Card(
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text(voice.voiceName),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return VoiceDetailPage(voice: voice, index: index);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // SettingPage build() 메서드에서 FloatingActionButton 추가
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: VoiceDetailPage(voice: VoiceModel.defaultValues(), index: -1),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
