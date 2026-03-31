import 'package:flutter/services.dart';

class AdhanNativeService {
  static const MethodChannel _channel = MethodChannel('com.sila.adhan/channel');

  static Future<void> playAdhan({String sound = 'adhan_egypt'}) async {
    try {
      await _channel.invokeMethod('playAdhan', {'sound': sound});
    } catch (e) {
      // ignore: avoid_print
      print('Error playing adhan: $e');
    }
  }

  static Future<void> stopAdhan() async {
    try {
      await _channel.invokeMethod('stopAdhan');
    } catch (e) {
      // ignore: avoid_print
      print('Error stopping adhan: $e');
    }
  }
}
