import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spell_of_victory/controller/SettingController.dart';

class SettingPage extends StatelessWidget {
  final SettingController settingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Obx(
            () => ListView(
          padding: EdgeInsets.all(20),
          children: [
            DropdownButtonFormField(
              value: settingController.settings.value.ttsLanguage,
              items: ['en-US', 'ko-KR'].map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'TTS Language',
              ),
              onChanged: (value) {
                settingController.updateTtsSettings(language: value);
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: settingController.settings.value.ttsEngine,
              items: ['default', 'flutterTts'].map((engine) {
                return DropdownMenuItem(
                  value: engine,
                  child: Text(engine),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'TTS Engine',
              ),
              onChanged: (value) {
                settingController.updateTtsSettings(engine: value);
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: settingController.settings.value.ttsVoiceType,
              items: [0, 1, 2, 3, 4, 5].map((voiceType) {
                return DropdownMenuItem(
                  value: voiceType,
                  child: Text(voiceType.toString()),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'TTS Voice Type',
              ),
              onChanged: (value) {
                settingController.updateTtsSettings(voiceType: value);
              },
            ),
            SizedBox(height: 20),
            Text(
              'TTS Volume: ${settingController.settings.value.ttsVolume.toStringAsFixed(2)}',
            ),
            SizedBox(height: 10),
            Slider(
              min: 0,
              max: 1,
              value: settingController.settings.value.ttsVolume,
              onChanged: (value) {
                settingController.updateTtsSettings(volume: value);
              },
            ),
            SizedBox(height: 20),
            Text(
              'TTS Pitch: ${settingController.settings.value.ttsPitch.toStringAsFixed(2)}',
            ),
            SizedBox(height: 10),
            Slider(
              min: 0.5,
              max: 2,
              value: settingController.settings.value.ttsPitch,
              onChanged: (value) {
                settingController.updateTtsSettings(pitch: value);
              },
            ),
            SizedBox(height: 20),
            Text(
              'TTS Rate: ${settingController.settings.value.ttsRate.toStringAsFixed(2)}',
            ),
            SizedBox(height: 10),
            Slider(
              min: 0.5,
              max: 2,
              value: settingController.settings.value.ttsRate,
              onChanged: (value) {
                settingController.updateTtsSettings(rate: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
