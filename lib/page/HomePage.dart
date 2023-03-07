import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts flutterTts = Get.find();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
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
              title: Text(category.name),
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
    );
  }
}