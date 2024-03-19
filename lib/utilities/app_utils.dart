import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String characters = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final Random random = Random();

String formatTime(int timeInSecond) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? '0$min' : '$min';
  String second = sec.toString().length <= 1 ? '0$sec' : '$sec';
  return '$minute : $second';
}

String getRandomString(int length) {
  return String.fromCharCodes(
    Iterable.generate(length, (_) => characters.codeUnitAt(random.nextInt(characters.length)))
  );
}

Color getRandomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

String getFormattedDate([DateTime? date]) {
  date ??= DateTime.now();
  return DateFormat('dd-MM-yyyy').format(date);
}
