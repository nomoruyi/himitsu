import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool isStringEmpty(String? string) => (string == null || string.trim().isEmpty || string.trim() == 'null');

bool isStringNotEmpty(String? string) => !isStringEmpty(string);

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'de_DE', symbol: '€', decimalDigits: 2);

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  bool isBefore(TimeOfDay other) => compareTo(other) < 0;
}

TimeOfDay stringToTime(String text) {
  List<String> timeSplit = text.split(':');
  return TimeOfDay(hour: int.parse(timeSplit[0]), minute: int.parse(timeSplit[1]));
}

extension DateTimeExtension on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}
