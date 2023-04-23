import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/controller/TutorialController.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:get/get.dart';

class MainDrawer extends StatelessWidget {

  final Function(int) setPage;

  const MainDrawer({Key? key, required this.setPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TutorialController tutorialController = Get.find<TutorialController>();

    List<TargetFocus> _createTargets() {
      List<TargetFocus> targets = [];

      // 1번 튜토리얼
      targets.add(
        TargetFocus(
          identify: "tutorial1",
          keyTarget: tutorialController.tutorialKey1,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "1번 튜토리얼",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );

      // 2번 튜토리얼
      targets.add(
        TargetFocus(
          identify: "tutorial2",
          keyTarget: tutorialController.tutorialKey2,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "2번 튜토리얼",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );

      // 3번 튜토리얼
      targets.add(
        TargetFocus(
          identify: "tutorial3",
          keyTarget: tutorialController.tutorialKey3,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "3번 튜토리얼",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );

      return targets;
    }

    void showTutorial() {
      TutorialCoachMark tutorialCoachMark = TutorialCoachMark(
        targets: _createTargets(),
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () {
          print("finish");
        },
        onClickTarget: (target) {
          print('onClickTarget: $target');
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          print("target: $target");
          print(
              "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        onClickOverlay: (target) {
          print('onClickOverlay: $target');
        },
        onSkip: () {
          print("skip");
        },
      );
      tutorialCoachMark.show(context: context);
    }

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
              // Box째 싹 초기화
              // await Hive.deleteFromDisk();
              // await HiveBoxes.init();
              
              // 내용물만 초기화
              HiveBoxes.settings.clear();
              HiveBoxes.voices.clear();
              HiveBoxes.choices.clear();
              HiveBoxes.categories.clear();
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('초기값 추가'),
            onTap: () async {
              await HiveBoxes.setInitData();
            },
          ),
          ListTile(
            leading: Icon(Icons.play_circle),
            title: Text('튜토리얼 시작'),
            onTap: () {
              // 페이지 전환
              setPage(1);
              setPage(2);
              setPage(0); 
              // drawer 종료 및 튜토리얼 시작
              Navigator.pop(context);
              showTutorial();
            },
          ),
        ],
      ),
    );
  }
}
