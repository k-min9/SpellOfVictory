import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/controller/EarphoneController.dart';
import 'package:spell_of_victory/controller/SettingController.dart';
import 'package:spell_of_victory/controller/TutorialController.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/model/SettingModel.dart';
import 'package:spell_of_victory/page/HomePage.dart';
import 'package:spell_of_victory/page/RegisterPage.dart';
import 'package:spell_of_victory/page/SettingPage.dart';
import 'package:get/get.dart';
import 'package:spell_of_victory/widgets/MainDrawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hive 초기화
  await Hive.initFlutter();
  await HiveBoxes.init();

  // FlutterTTS 인스턴스 생성 후 초기화 및 등록
  final FlutterTts flutterTts = FlutterTts();
  Get.put(flutterTts);

  ///TODO : 가능한 엔진 미리 init하여 Preloading
  // final engines = await flutterTts.getEngines;
  // try {
  //   for (dynamic engine in engines) {
  //     await flutterTts.setEngine(engine!);
  //   }
  // } catch (e) {
  //   flutterTts.setEngine('com.google.android.tts');
  // }


  // SettingController 등록
  Get.put(SettingController());

  // EarphoneController 등록
  // final EarphoneController earphoneController = Get.put(EarphoneController());
  // earphoneController.checkEarphoneConnection();
  // earphoneController.registerEarphoneConnectivity();

  // TutorialController 등록
  Get.put(TutorialController());

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

  // Ads
  MobileAds.instance.initialize();

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

  // 두번 누르면 아웃
  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    print('?');
    final DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2))
    {
      currentBackPressTime = now;
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: '한 번 더 뒤로가기를 누르시면 종료됩니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawer: MainDrawer(setPage: setPage),
          appBar: AppBar(
            centerTitle: true,
            title: Text('TTS App', textAlign: TextAlign.center,),
          ),
          body: WillPopScope(
            onWillPop: _onWillPop,
            child: _pages[_currentIndex]
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Spells',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Content',
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
  
  // Tutorial용 페이지 전환
  void setPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }
}
