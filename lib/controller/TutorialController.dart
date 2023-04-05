import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialController extends GetxController {
  late TutorialCoachMark _tutorialCoachMark;
  TutorialCoachMark get tutorialCoachMark => _tutorialCoachMark;

  GlobalKey _tutorialKey1 = GlobalKey();
  GlobalKey get tutorialKey1 => _tutorialKey1;
  GlobalKey _tutorialKey2 = GlobalKey();
  GlobalKey get tutorialKey2 => _tutorialKey2;
  GlobalKey _tutorialKey3 = GlobalKey();
  GlobalKey get tutorialKey3 => _tutorialKey3;

}
