import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:get/get.dart';

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
    return Column(
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
                        children: choice.texts.map((text) => Column(
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
                            )
                          ],
                        )).toList(),
                      ),
                      Divider(height: 1, thickness: 2,)
                    ],
                  );
                },
              );
            },
          ),
        ),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Enter text',
            contentPadding: EdgeInsets.all(10),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => {}//_addText(0),
            ),
          ),
        ),
      ],
    );
  }
}