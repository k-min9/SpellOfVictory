import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/controller/SettingController.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/model/SettingModel.dart';
import 'package:spell_of_victory/page/HomePage.dart';
import 'package:spell_of_victory/page/RegisterPage.dart';
import 'package:spell_of_victory/page/SettingPage.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hive 초기화
  await Hive.initFlutter();
  await HiveBoxes.init();

  // FlutterTTS 인스턴스 생성 후 초기화 및 등록
  final FlutterTts flutterTts = FlutterTts();
  Get.put(flutterTts);

  // SettingController 등록
  Get.put(SettingController());

  // 기본 데이터 세팅 없으면 세팅
  if (Hive.box<SettingModel>('settings').isEmpty) {
    await Hive.box<SettingModel>('settings').add(
      SettingModel(
        isFirstVisit: true,
        isTutorialNeeded: true,
        ttsEngine: '',
        ttsLanguage: 'en-US',
        ttsVoiceType: 0,
        ttsVolume: 0.5,
        ttsPitch: 1.0,
        ttsRate: 0.5,
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<Widget> _pages = [HomePage(), RegisterPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('TTS App'),
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
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
                icon: Icon(Icons.volume_up),
                label: 'Voice',
              ),
            ],
          ),
        )
    );
  }
}
