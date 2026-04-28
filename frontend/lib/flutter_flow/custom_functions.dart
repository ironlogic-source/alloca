import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

List<MessageStruct> sortMessages(List<MessageStruct> messages) {
  final order = {'HIGH': 0, 'MEDIUM': 1, 'LOW': 2};
  final sorted = List<MessageStruct>.from(messages);
  sorted.sort(
      (a, b) => (order[a.priority] ?? 3).compareTo(order[b.priority] ?? 3));
  return sorted;
}
