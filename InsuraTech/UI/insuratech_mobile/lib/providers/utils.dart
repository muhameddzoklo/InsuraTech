import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

String formatDate(DateTime date) {
  return DateFormat('dd.MM.yyyy.').format(date);
}

String formatDateString(String? dateString) {
  if (dateString == null || dateString.isEmpty) return '-';
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd.MM.yyyy.').format(date);
  } catch (e) {
    return '-';
  }
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}
