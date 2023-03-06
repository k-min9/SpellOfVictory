import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:get/get.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FlutterTts flutterTts = Get.find();

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
                valueListenable: Hive.box<ChoiceModel>('choice').listenable(),
                builder: (context, Box<ChoiceModel> box, _) {
                  final choices = box.values.toList();
                  return ListView.builder(
                    itemCount: choices.length,
                    itemBuilder: (context, index) {
                      final choice = choices[index];
                      return Column(
                        children: [
                          ExpansionTile(
                              title: Text(choice.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              children: [
                                ...choice.texts.map((text) => Column(
                                  children: [
                                    Divider(height: 1, thickness: 1),
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(child: Text(text.content)),
                                          SizedBox(width: 3),
                                          IconButton(onPressed: () {
                                            flutterTts.speak(text.content);
                                            print("text speak : " + text.content);
                                          },
                                              icon: Icon(Icons.volume_up), splashRadius: 18
                                          ),
                                          SizedBox(width: 3),
                                          IconButton(onPressed: () {}, icon: Icon(Icons.save_alt), splashRadius: 18)
                                        ],
                                      ),
                                      onTap: () {
                                        // flutterTts.speak(text.content);
                                        // print("text speak : " + text.content);
                                      },
                                    ),
                                  ],
                                )).toList(),
                                TextField(
                                  controller: _textEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter text',
                                    contentPadding: EdgeInsets.all(10),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        // Add new text
                                        final textContent = _textEditingController.text;
                                        final newText = ChoiceTextModel(content: textContent, isChoiceSelected: false);
                                        choice.texts.add(newText);
                                        _textEditingController.clear();
                                      },
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          Divider(height: 1, thickness: 2,),
                        ],
                      );
                    },
                  );
                },
              ),

            ),
            SizedBox(height: 10),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
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
                          final newChoice = ChoiceModel(name: _textEditingController.text, texts: [], isSelected: false);
                          HiveBoxes.choices.add(newChoice);
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
        ),
      ],
    );
  }
}
