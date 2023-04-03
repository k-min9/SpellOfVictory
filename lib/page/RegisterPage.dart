import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:get/get.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/widgets/ChoiceInputDialog.dart';
import 'package:spell_of_victory/widgets/DashedDivider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FlutterTts flutterTts = Get.find();

  // 광고 관련
  final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-8480822096988962/9822153113',
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',  // for test
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      )
  )..load();

  // 삭제
  List<int> checkedList = [];
  bool isCheckable = false;


  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<ChoiceModel>('choice').listenable(),
                  builder: (context, Box<ChoiceModel> box, _) {
                    if (box.values.isEmpty) {
                      return Center(
                        child: Text('등록한 주문이 없습니다.'),
                      );
                    }
                    // final choices = box.values.toList();
                    return ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: box.length,
                      onReorder: (oldIndex, newIndex) async {
                        if (newIndex != oldIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }

                          final oldItem = box.getAt(oldIndex);
                          await box.deleteAt(oldIndex);

                          if (oldItem != null) {
                            final oldItem2 = ChoiceModel(name: oldItem.name, texts: oldItem.texts, isSelected: oldItem.isSelected);
                            box.add(ChoiceModel(name: "swap", texts: [], isSelected: false));  // index, length용 더미
                            final lastIndex = box.length - 1;
                            for (var i = lastIndex; i > newIndex; i--) {
                              final previous = await box.getAt(i - 1);
                              await box.putAt(i, ChoiceModel(name: previous!.name, texts: previous!.texts, isSelected: previous!.isSelected)!);
                            }
                            await box.putAt(newIndex, oldItem2);
                          }
                        }
                      },
                      itemBuilder: (context, index) {
                        final ChoiceModel choice =
                        box.getAt(index) as ChoiceModel;
                        return Column(
                          key: UniqueKey(),
                          children: [
                            ExpansionTile(
                                onExpansionChanged: (isExpanded) {
                                  _textEditingController.clear();
                                },
                                leading: !isCheckable?
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  child: Icon(Icons.circle, size: 12),
                                )
                                    :
                                Checkbox(
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
                                ),
                                trailing: isCheckable?
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(Icons.drag_handle),
                                ):null,
                                title: GestureDetector(
                                    onLongPress: () {
                                      checkedList = [];
                                      checkedList.add(index);

                                      setState(() {
                                        isCheckable = !isCheckable;
                                      });
                                    },
                                    onTap: () {
                                      if(isCheckable) {
                                        setState(() {
                                          if (checkedList.contains(index)) {
                                            checkedList.remove(index);
                                            // 선택된 것이 없으면 자동으로 초기화
                                            if (checkedList.isEmpty) isCheckable = !isCheckable;
                                          } else {
                                            checkedList.add(index);
                                          }
                                        });
                                      }
                                    },
                                    child: Text(choice.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                                ),
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
                                  DashedDivider(color: Colors.grey),
                                  TextField(
                                    controller: _textEditingController,
                                    decoration: InputDecoration(
                                      hintText: '+ 주문 텍스트 추가',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.all(10),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.add_to_home_screen),
                                        onPressed: () {
                                          // Add new text
                                          final textContent = _textEditingController.text;
                                          final newText = ChoiceTextModel(content: textContent, isChoiceSelected: false);
                                          choice.texts.add(newText);
                                          box.putAt(index, choice);
                                          _textEditingController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            Divider(height: 1, thickness: 2),
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
        ],
      ),
      floatingActionButton: !isCheckable?
      FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ChoiceInputDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ):
      FloatingActionButton(
        onPressed: () {
          _deleteSelectedItems();
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.redAccent,
      ),
    );
  }


  void _deleteSelectedItems() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: '삭제 확인',
        text: '${checkedList.length}개의 주문서를 삭제하시겠습니까?',
        confirmBtnText: '확인',
        cancelBtnText: '취소',
        showCancelBtn: true,
        reverseBtnOrder: true,
        onConfirmBtnTap: () async {
          List<int> sortedIndexes = checkedList.toList()..sort();
          for (int i = sortedIndexes.length - 1; i >= 0; i--) {
            int index = sortedIndexes[i];
            await HiveBoxes.choices.deleteAt(index);
          }

          // 삭제 후 상태 초기화
          isCheckable = false;
          checkedList = [];
          _showSimpleToast("삭제되었습니다");
        }
    );
  }

  void _showSimpleToast(String msgText) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msgText,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
