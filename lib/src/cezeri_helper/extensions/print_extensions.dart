import 'dart:convert';

import 'package:flutter/material.dart';

extension PrintExtensions on Object {
  void printCZRPrettyJson() => debugPrint(JsonEncoder.withIndent('  ').convert(this));
}
