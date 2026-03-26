import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeUtils {
  static String formatPrayerTime(DateTime time, BuildContext context) {
    final lang = context.locale.languageCode;
    final formattedTime = DateFormat('hh:mm').format(time);
    final isAM = time.hour < 12 && time.hour > 0;
    // Edge cases for 12 AM and 12 PM
    final realIsAm = time.hour < 12;

    if (lang == 'ar') {
      final period = realIsAm ? 'ص' : 'م';
      const numMap = {
        '0': '٠', '1': '١', '2': '٢', '3': '٣', '4': '٤',
        '5': '٥', '6': '٦', '7': '٧', '8': '٨', '9': '٩'
      };
      final arabicTime = formattedTime.split('').map((c) => numMap[c] ?? c).join();
      return '$arabicTime $period';
    } 
    
    final period = realIsAm ? 'AM' : 'PM';
    return '$formattedTime $period';
  }
}
