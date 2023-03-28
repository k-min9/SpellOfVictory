import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/model/VoiceModel.dart';
import 'package:spell_of_victory/page/VoiceDetailPage.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<int> checkedList = [];
  bool isCheckable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Voice List'),
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
                  margin: EdgeInsets.all(3.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    title: Text(voice.voiceName),
                    onLongPress: () {
                      checkedList = [];
                      checkedList.add(index);

                      setState(() {
                        isCheckable = !isCheckable;
                      });
                    },
                    leading: isCheckable
                        ? Checkbox(
                      value: checkedList.contains(index),
                      onChanged: (_) {
                        setState(() {
                          if (checkedList.contains(index)) {
                            checkedList.remove(index);
                            // 선택된 것이 없으면 자동으로 초기화
                            if (checkedList.isEmpty) isCheckable = !isCheckable;
                          } else {
                            checkedList.add(index);
                          }
                        });
                      },
                    )
                        : null,
                    onTap: () {
                      !isCheckable?
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: VoiceDetailPage(voice: voice, index: index));
                        },
                      )
                      :
                      setState(() {
                        if (checkedList.contains(index)) {
                          checkedList.remove(index);
                          // 선택된 것이 없으면 자동으로 초기화
                          if (checkedList.isEmpty) isCheckable = !isCheckable;
                        } else {
                          checkedList.add(index);
                        }
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
        // SettingPage build() 메서드에서 FloatingActionButton 추가
        floatingActionButton: !isCheckable?
        FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child:
                  VoiceDetailPage(voice: VoiceModel.defaultValues(), index: -1),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ):
        null,
        // 삭제 버튼 추가
        persistentFooterButtons: isCheckable?
        [
          ElevatedButton(
            onPressed: () {
              _deleteSelectedItems();
            },
            child: Text('삭제'),
          ),
        ]:
        null
    );
  }

  void _deleteSelectedItems() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('${checkedList.length}개의 음성을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                List<int> sortedIndexes = checkedList.toList()..sort();
                for (int i = sortedIndexes.length - 1; i >= 0; i--) {
                  int index = sortedIndexes[i];
                  await HiveBoxes.voices.deleteAt(index);
                }
                Navigator.of(context).pop();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${checkedList.length}개의 음성이 삭제되었습니다.'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // 삭제 후 상태 초기화
                isCheckable = false;
                checkedList = [];
              },
            ),
          ],
        );
      },
    );
  }
}
