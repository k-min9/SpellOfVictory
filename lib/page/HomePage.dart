import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:get/get.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/model/VoiceModel.dart';
import 'package:spell_of_victory/widgets/CategoryInputDialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomePageState extends State<HomePage> {
  // TTS 관련
  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  late List<CategoryTextModel> ttsPlayList = [];
  int ttsPlayIndex = 0;
  double ttsWaitingTime = 0;
  int cateNum = 0;  // 등록된 카테고리 숫자
  int textNum = 0;  // 등록된 주문 수

  // 삭제
  List<int> checkedList = [];
  bool isCheckable = false;

  void _setTtsPlayList() {
    cateNum = 0;
    textNum = 0;
    ttsPlayList = [];
    ttsPlayIndex = 0;
    ttsWaitingTime = 0;
    _stop();
    final categoriesBox = Hive.box<CategoryModel>('categories');
    for (int i = 0; i < categoriesBox.length; i++) {
      final category = categoriesBox.getAt(i) as CategoryModel;
      if (category.isSelected) {
        cateNum++;
        for (int j= 0; j < category.texts.length; j++) {
          // 일단은 컨텐츠 추가 확인 안함
          ttsPlayList.add(category.texts[j]);
          textNum++;
        }
      }
    }
  }

  Future<void> _setTtsSettingByName(String name) async {
    print(name);
    // 해당 이름의 voice가 있다면 사용, 없으면 default
    VoiceModel? voice;
    try {
      voice = HiveBoxes.voices.values.firstWhere((voice) => voice.voiceName == name);
    } catch (e) {
      voice = null;
    }

    if (voice != null) {
      try {
        await flutterTts.setEngine(voice.ttsEngine);
        await flutterTts.setLanguage(voice.ttsLanguage);
        await flutterTts.setVolume(voice.ttsVolume);
        await flutterTts.setPitch(voice.ttsPitch);
        await flutterTts.setSpeechRate(voice.ttsRate);
      } catch (e) {
        await flutterTts.setEngine("com.google.android.tts");
        await flutterTts.setLanguage("'ko-KR'");
        await flutterTts.setVolume(0.5);
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.5);
      }
    } else {
      await flutterTts.setEngine("com.google.android.tts");
      await flutterTts.setLanguage("'ko-KR'");
      await flutterTts.setVolume(0.5);
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
    }
  }

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
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        // 재생 후, 다음 play 세팅
        ttsPlayIndex += 1;
        ttsWaitingTime = 0.5; // 임시. 여기서 할 필요 없어보이는데?

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                    return ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: categoriesBox.length,
                      onReorder: (oldIndex, newIndex) async {
                        if (newIndex != oldIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }

                          final oldItem = categoriesBox.getAt(oldIndex);
                          await categoriesBox.deleteAt(oldIndex);

                          if (oldItem != null) {
                            final oldItem2 = CategoryModel(name: oldItem.name, texts: oldItem.texts, isSelected: oldItem.isSelected);
                            categoriesBox.add(CategoryModel(name: "swap", texts: [], isSelected: false));  // index, length용 더미
                            final lastIndex = categoriesBox.length - 1;
                            for (var i = lastIndex; i > newIndex; i--) {
                              final previous = await categoriesBox.getAt(i - 1);
                              await categoriesBox.putAt(i, CategoryModel(name: previous!.name, texts: previous!.texts, isSelected: previous!.isSelected)!);
                            }
                            await categoriesBox.putAt(newIndex, oldItem2);
                          }
                        }
                      },
                      itemBuilder: (context, index) {
                        final CategoryModel category =
                        categoriesBox.getAt(index) as CategoryModel;
                        return ExpansionTile(
                          leading: !isCheckable?
                          IconButton(
                            icon: Icon(
                              Icons.menu_book,
                              color: category.isSelected ? Colors.blue : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                category.isSelected = !category.isSelected;
                                categoriesBox.putAt(index, category);
                                if (category.isSelected) _showSimpleToast("재생목록에 추가되었습니다.");
                                else if (!category.isSelected) _showSimpleToast("재생목록에서 제거되었습니다.");
                              });
                            },
                          )
                          :
                          Wrap(
                            // spacing: -3,
                            children: [
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
                              IconButton(
                                icon: Icon(
                                  Icons.menu_book,
                                  color: category.isSelected ? Colors.blue : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    category.isSelected = !category.isSelected;
                                    categoriesBox.putAt(index, category);
                                    if (category.isSelected) _showSimpleToast("재생목록에 추가되었습니다.");
                                    else if (!category.isSelected) _showSimpleToast("재생목록에서 제거되었습니다.");
                                  });
                                },
                              )
                            ],
                          )
                          ,
                          trailing: isCheckable?
                          ReorderableDragStartListener(
                            index: index,
                            child: Icon(Icons.drag_handle),
                          ):null,
                          key: ValueKey(index),
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
                            child: Text(
                                category.name + " (" + category.texts.length.toString() + ")",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                            // Row(
                            //   children: [
                            //     Expanded(child: Text(
                            //         category.name + " (" + category.texts.length.toString() + ")",
                            //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                            //     ),
                            //     ReorderableDragStartListener(
                            //       index: index,
                            //       child: Icon(Icons.drag_handle),
                            //     ),
                            //     SizedBox(width: 3),
                            //     IconButton(
                            //         onPressed: () {
                            //           _showModal(context, index);
                            //         }, icon: Icon(Icons.add), splashRadius: 18),
                            //   ],
                            // ),
                          ),
                          children: [
                            ReorderableListView(
                              buildDefaultDragHandles: false,
                              physics: NeverScrollableScrollPhysics(),  // 밖의 스크롤에 영향을 미치지 않게 설정
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: <Widget>[
                                for(int idx = 0; idx < category.texts.length; idx++)
                                  ListTile(
                                    key: UniqueKey(),
                                    title: Text(category.texts[idx].content),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            print('hello');
                                            // 카테고리 삭제
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.confirm,
                                                title: '삭제 확인',
                                                text: '정말 삭제하시겠습니까?',
                                                confirmBtnText: '확인',
                                                cancelBtnText: '취소',
                                                showCancelBtn: true,
                                                reverseBtnOrder: true,
                                                onConfirmBtnTap: () async {
                                                  category.texts.removeAt(idx);
                                                  final newCategory = CategoryModel(name: category.name, texts: category.texts, isSelected: category.isSelected);
                                                  await categoriesBox.putAt(index, newCategory);
                                                  _showSimpleToast("삭제되었습니다");
                                                }
                                            );
                                          },
                                          child: AbsorbPointer(
                                            child: Icon(Icons.delete),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        ReorderableDragStartListener(
                                          index: idx,
                                          child: Icon(Icons.drag_handle),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                              onReorder: (oldIndex, newIndex) {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }

                                final oldItem = category.texts.removeAt(oldIndex);
                                category.texts.insert(newIndex, oldItem);

                                final newCategory = CategoryModel(name: category.name, texts: category.texts, isSelected: category.isSelected);

                                categoriesBox.putAt(index, newCategory);
                              },
                            ),
                            ListTile(
                              title: Center(child:Text('주문 추가')),
                              // tileColor: Colors.yellowAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onTap: () {
                                _showModal(context, index);
                              },
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              _btnSection(),
              SizedBox(height: 15),
            ],
          )
        ],
      ),
      floatingActionButton: !isCheckable?
      FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CategoryInputDialog();
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

  CategoryModel? _swapCategory(Box<CategoryModel> categoriesBox, int oldIndex, int newIndex) {
    final oldItem = categoriesBox.getAt(oldIndex);
    final newItem = categoriesBox.getAt(newIndex);

    if (newItem != null && oldItem != null) {
      final oldItem2 = CategoryModel(name: oldItem.name, texts: oldItem.texts, isSelected: oldItem.isSelected);
      final newItem2 = CategoryModel(name: newItem.name, texts: newItem.texts, isSelected: newItem.isSelected);
      categoriesBox.putAt(oldIndex, newItem2);
      categoriesBox.putAt(newIndex, oldItem2);
    }
    return oldItem;
  }


  // 재생기(임시)
  Widget _btnSection() {
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              Colors.green, Colors.greenAccent, Icons.play_arrow, 'PLAY', _speakStart),
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

  Future _speakStart() async {
    _setTtsPlayList();
    if(ttsPlayList.length == 0) {
      _showSimpleToast("등록된 주문서가 없습니다.");
      _stop();
    } else {
      _showSimpleToast(cateNum.toString() + "개의 주문서를 재생하겠습니다.");
      _speak();
    }
  }

  Future _speak() async {
    if (ttsWaitingTime != 0) await Future.delayed(Duration(milliseconds: (1000*ttsWaitingTime).toInt()));
    if (ttsPlayList.length <= ttsPlayIndex) ttsPlayIndex = 0;
    await _setTtsSettingByName(ttsPlayList[ttsPlayIndex].voiceName);  // TTS 속성 설정
    var result = await flutterTts.speak(ttsPlayList[ttsPlayIndex].content);
    ttsWaitingTime = ttsPlayList[ttsPlayIndex].watingTime;
  }

  // Future _setAwaitOptions() async {
  //   await flutterTts.awaitSpeakCompletion(true);
  // }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
    ttsWaitingTime = 0;
    if(ttsPlayList.length != 0) _showSimpleToast("주문서 재생을 중지");
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
    _showSimpleToast("주문서 재생 일시정지");
  }

  // 카테고리 내용 추가
  void _showModal(BuildContext context, int index) {
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
                  _showMultipleModal(context, index);
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
  void _showMultipleModal(BuildContext context, int idx) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      // isDismissible: false, // 외부 Modal이 닫히지 않도록 설정
      builder: (BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                leading: Container(), middle: Text('Modal Page')),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final choice in HiveBoxes.choices.values)
                      _buildChoiceTitleModal(context, choice.name, choice.texts, idx),
                  ],
                )
              ),
            )
        );
      },
    );
  }

  Widget _buildChoiceTitleModal(BuildContext context, String name, List<ChoiceTextModel> texts, int idx) {
    return Material(
        child: Column(
            children: [
              ListTile(
                title: Text(name),
                onTap: () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => _buildChoiceTextModal(context, texts, idx),
                  backgroundColor: Colors.transparent,
                  // isDismissible: false,
                  expand: true,
                ),
              ),
              Divider(height: 2, thickness: 1.4),
            ]
        )
    );
  }

  Widget _buildChoiceTextModal(BuildContext context, List<ChoiceTextModel> texts, int idx) {
    return Material(
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                leading: Container(), middle: Text('Modal Page')),
            child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [ListView.builder(
                        shrinkWrap: true,
                        itemCount: texts.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                  title: Text(texts[index].content),
                                  trailing: IconButton(
                                      onPressed: () {
                                        final box = Hive.box<CategoryModel>('categories');
                                        CategoryModel category = box.getAt(idx)!;
                                        category.texts.add(CategoryTextModel(content:texts[index].content, isContentSelected: false, voiceName: 'NA', watingTime: 0));
                                        box.putAt(idx, category);

                                        // add 추가 toast
                                        _showSimpleToast("주문을 추가하였습니다.");
                                      },
                                      icon: Icon(Icons.add),
                                      splashRadius: 18
                                  )
                              ),
                              Divider(height: 2, thickness: 1.4),
                            ],
                          );
                        },
                      ),
                      ]
                  )
                )
            )
        )
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
              // onTap: () => _showMultipleModal(context),
              onTap: () => _handleItemClick(title, texts[index].content),
            );
          },
        ),
      ],
    );
  }

  void _handleItemClick(String title, String content) {
    print('Clicked: $title - $content');
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
            await HiveBoxes.categories.deleteAt(index);
          }

          // 삭제 후 상태 초기화
          isCheckable = false;
          checkedList = [];
          _showSimpleToast("삭제되었습니다");
        }
    );
  }
}