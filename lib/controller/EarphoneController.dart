import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EarphoneController extends GetxController {
  final MethodChannel _channel = const MethodChannel('plugins.flutter.io/android_intent');

  RxBool isEarphoneConnected = false.obs;

  void checkEarphoneConnection() {
    bool isConnected = false;
    SystemChannels.platform.invokeMethod<bool>('SystemSound.areSoundEffectsEnabled')
        .then((value) => isConnected = value ?? false)
        .whenComplete(() => isEarphoneConnected.value = isConnected);
    _showSimpleToast(isEarphoneConnected.toString());
  }

  // 이어폰 연결 이벤트 감지
  void registerEarphoneConnectivity() {
    _channel.invokeMethod<void>('registerEarphoneConnectivity');
    _channel.setMethodCallHandler((MethodCall call) async {
      print(call.method);
      _showSimpleToast(call.method);
      switch (call.method) {
        case "onEarphoneConnected":
        // TTS speak 작동
        //   if (await flutterTts.getEarphoneConnection()) {
        //     await flutterTts.speak('Hello, world!');
        //   }
          break;
        case "onEarphoneDisconnected":
        // TTS speak 중지
        //   await flutterTts.stop();
          break;
      }
    });
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