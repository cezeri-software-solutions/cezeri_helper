import 'dart:convert';

import 'package:flutter/widgets.dart';

void printCZRPrettyJson(Map<String, dynamic> jsonMap) {
  const encoder = JsonEncoder.withIndent('  '); // Zwei Leerzeichen zur Einrückung
  final prettyJson = encoder.convert(jsonMap);
  debugPrint(prettyJson);
}
