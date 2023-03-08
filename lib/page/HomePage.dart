import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:get/get.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  // TTS 관련
  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;

  @override
  void initState() {
    super.initState();
    flutterTts = Get.find();
    // await flutterTts.awaitSpeakCompletion(true);

    // 시작시
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      if (ttsState == TtsState.playing) {
        _speak();
      } else {
        setState(() {
          print("Complete");
          ttsState = TtsState.stopped;
        });
      }
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }


  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<CategoryModel>('categories').listenable(),
                builder: (context, Box<CategoryModel> categoriesBox, _) {
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
                        title: Row(
                          children: [
                            Expanded(child: Text(category.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                            SizedBox(width: 3),
                            IconButton
                              (onPressed: () {
                              _showModal(context);
                              }, icon: Icon(Icons.add), splashRadius: 18),
                            SizedBox(width: 3),
                            IconButton(
                                onPressed: () {
                              categoriesBox.deleteAt(index);
                              }, icon: Icon(Icons.delete), splashRadius: 18)
                          ],
                        ),
                        children: category.texts
                            .map((text) => ListTile(
                          title: Text(text.content),
                          onTap: () {},
                        ))
                            .toList(),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            _btnSection(),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("새로운 선택지"),
                      content: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: '선택지 이름을 적어주세요.',
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            final newCategory = CategoryModel(name: _textEditingController.text, texts: [], isSelected: false);
                            HiveBoxes.categories.add(newCategory);
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Text(
                  '새로운 카테고리',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        )
      ],
    );
  }

  // 재생기(임시)
  Widget _btnSection() {
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Colors.green, Colors.greenAccent, Icons.play_arrow,
              'PLAY', _speak),
          _buildButtonColumn(
              Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
          _buildButtonColumn(
              Colors.blue, Colors.blueAccent, Icons.pause, 'PAUSE', _pause),
        ],
      ),
    );
  }

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  Future _speak() async {
    String text = "안녕하십니까. TTS 테스트 중입니다.";
    var result = await flutterTts.speak(text);
    print("_speak result : " + result.toString());
  }

  // Future _setAwaitOptions() async {
  //   await flutterTts.awaitSpeakCompletion(true);
  // }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  // 카테고리 내용 추가
  void _showModal(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('직접 추가'),
                leading: Icon(Icons.edit),
                onTap: () {
                  // Do something
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                title: Text('주문 리스트에서 가져오기'),
                leading: Icon(Icons.list),
                onTap: () {
                  // Show choices
                  _showMultipleModal(context);
                },
              ),
              Divider(),
              ListTile(
                title: Text('취소'),
                leading: Icon(Icons.cancel),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // choice에서 카테고리 내용 가져오기
  void _showMultipleModal(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: HiveBoxes.choices.values.map((choice) {
            return _buildModal(context, choice.name, choice.texts);
          }).toList(),
        );
      },
    );
  }

  Widget _buildModal(BuildContext context, String title, List<ChoiceTextModel> texts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Theme.of(context).primaryColor,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: texts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(texts[index].content),
              onTap: () => _showMultipleModal(context),
              // onTap: () => _handleItemClick(title, texts[index].content),
            );
          },
        ),
      ],
    );
  }

  void _handleItemClick(String title, String content) {
    print('Clicked: $title - $content');
  }
}