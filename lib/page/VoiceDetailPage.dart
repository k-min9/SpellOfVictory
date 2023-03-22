import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spell_of_victory/model/HiveBoxes.dart';
import 'package:spell_of_victory/model/VoiceModel.dart';
import 'package:get/get.dart';

class VoiceDetailPage extends StatefulWidget {
  final VoiceModel voice;
  final int index;

  const VoiceDetailPage({required this.voice, required this.index});

  @override
  _VoiceDetailPageState createState() => _VoiceDetailPageState();
}

class _VoiceDetailPageState extends State<VoiceDetailPage> {
  late String _voiceName;
  late String _ttsEngine;
  late String _ttsLanguage;
  late int _ttsVoiceType;
  late double _ttsVolume;
  late double _ttsPitch;
  late double _ttsRate;
  late String _ttsLocale;

  // TTS 관련
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = Get.find();
    _voiceName = widget.voice.voiceName;
    _ttsEngine = widget.voice.ttsEngine;
    // flutterTts.setEngine(_ttsEngine);  // 초기값 세팅용
    _ttsLanguage = widget.voice.ttsLanguage;
    _ttsVoiceType = widget.voice.ttsVoiceType;
    _ttsVolume = widget.voice.ttsVolume;
    _ttsPitch = widget.voice.ttsPitch;
    _ttsRate = widget.voice.ttsRate;
    _ttsLocale = widget.voice.ttsLocale;
    if (_ttsLocale == null || _ttsLocale.isEmpty) {
      _ttsLocale = window.locale.languageCode;
    }
  }

  // TTS 관련 리스트
  late List<String> languages;
  Future<dynamic> _getEngines() async => await flutterTts.getEngines;
  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;
  String _getDefaultLanguage() {
    String ret = 'ko-KR';
    for (String language in languages) {
      if (language.contains(_ttsLocale)) {
        ret = language;
        break;
      }
    }
    return ret;
  }

  //Android용
  Widget _engineSection() {
    return FutureBuilder<dynamic>(
        future: _getEngines(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _enginesDropDownSection(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('Error loading engines...');
          } else
            return Text('Loading engines...');
        });
  }

  Widget _enginesDropDownSection(dynamic engines) => Container(
    child: DropdownButtonFormField(
      value: _ttsEngine,
      items: getEnginesDropDownMenuItems(engines),
      onChanged: (String? selectedEngine) async {
        await flutterTts.setEngine(selectedEngine!);  // getLanguage를 위한 임시 설정
        await _getLanguages();  // languages 안전하게 구축
        _ttsLanguage = _getDefaultLanguage();
        setState(() {
          _ttsEngine = selectedEngine!;
        });
      },
    ),
  );

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?,
          child: Text(type as String)
      )
      );}
    return items;
  }

  Widget _LanguageSection() => FutureBuilder<dynamic>(
      future: _getLanguages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          languages = [];
          for (String language in snapshot.data) {
            languages.add(language);
          }
          return _languageDropDownSection(snapshot.data);
        } else if (snapshot.hasError) {
          return Text('Error loading languages...');
        } else
          return Text('Loading Languages...');
      });

  Widget _languageDropDownSection(dynamic languages) => Container(
      child: DropdownButtonFormField(
        value: _ttsLanguage,
        items: getLanguageDropDownMenuItems(languages),
        onChanged: (String? selectedType) {
          setState(() {
            _ttsLanguage = selectedType!;
            if (_ttsLanguage.contains('-')) _ttsLocale = _ttsLanguage.substring(0, 2);
          });
        },
      ),
  );

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text('Voice Detail')),
            IconButton(
                onPressed: () async {
                  // TTS 세팅
                  await flutterTts.setEngine(_ttsEngine);
                  await flutterTts.setLanguage(_ttsLanguage);
                  await flutterTts.setVolume(_ttsVolume);
                  await flutterTts.setPitch(_ttsPitch);
                  await flutterTts.setSpeechRate(_ttsRate);

                  // 샘플보이스
                  var random = Random();
                  await flutterTts.stop();
                  if (_ttsLanguage.contains('ko')) {
                    List<String> samples = ['안녕하세요', '테스트 문장입니다.', '오늘도 좋은 하루되세요'];
                    await flutterTts.speak(samples[random.nextInt(3)]);
                  } else {
                    List<String> samples = ['hello', 'sample voice here', 'have a good day'];
                    await flutterTts.speak(samples[random.nextInt(3)]);
                  }
                },
                icon: Icon(Icons.volume_up)
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Voice Name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            TextFormField(
              initialValue: _voiceName,
              onChanged: (value) {
                setState(() {
                  _voiceName = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('TTS Engine', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            _engineSection(),
            SizedBox(height: 16),
            Text('TTS Language', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            _LanguageSection(),
            // DropdownButtonFormField<String>(
            //   value: _ttsLanguage,
            //   items: [
            //     DropdownMenuItem<String>(
            //       value: 'ko-KR',
            //       child: Text('한국어'),
            //     ),
            //     DropdownMenuItem<String>(
            //       value: 'en-US',
            //       child: Text('영어'),
            //     ),
            //   ],
            //   onChanged: (value) {
            //     setState(() {
            //       _ttsLanguage = value!;
            //     });
            //   },
            // ),
            SizedBox(height: 16),
            Text('TTS Voice Type', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _ttsVoiceType,
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Type 1'),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Type 2'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Type 3'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _ttsVoiceType = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('TTS Volume', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Slider(
              value: _ttsVolume,
              min: 0,
              max: 1,
              divisions: 10,
              label: 'Volume: $_ttsVolume',
              onChanged: (value) {
                setState(() {
                  _ttsVolume = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('TTS Pitch', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Slider(
              value: _ttsPitch,
              min: 0,
              max: 2,
              divisions: 20,
              label: 'Pitch: $_ttsPitch',
              onChanged: (value) {
                setState(() {
                  _ttsPitch = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('TTS Rate', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Slider(
              value: _ttsRate,
              min: 0.5,
              max: 2,
              divisions: 15,
              label: 'Rate: $_ttsRate',
              onChanged: (value) {
                setState(() {
                  _ttsRate = value;
                });
              },
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            VoiceModel voice = VoiceModel(voiceName: _voiceName, ttsEngine: _ttsEngine,
                ttsLanguage: _ttsLanguage, ttsVoiceType: _ttsVoiceType, ttsVolume: _ttsVolume,
                ttsPitch: _ttsPitch, ttsRate: _ttsRate, ttsLocale: _ttsLocale);
            // 신규 추가
            if (widget.index == -1) {
              HiveBoxes.voices.add(voice);
            // 기존 수정
            } else {
              HiveBoxes.voices.putAt(widget.index, voice);
            }
            Navigator.of(context).pop(true);
          },
          child: Text('확인'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}
