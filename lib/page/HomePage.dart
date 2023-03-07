import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:get/get.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                            IconButton(onPressed: () {
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
}