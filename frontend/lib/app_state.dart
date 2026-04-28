import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _selectedTab = 'home';
  String get selectedTab => _selectedTab;
  set selectedTab(String value) {
    _selectedTab = value;
  }

  List<MessageStruct> _allMessages = [];
  List<MessageStruct> get allMessages => _allMessages;
  set allMessages(List<MessageStruct> value) {
    _allMessages = value;
  }

  void addToAllMessages(MessageStruct value) {
    allMessages.add(value);
  }

  void removeFromAllMessages(MessageStruct value) {
    allMessages.remove(value);
  }

  void removeAtIndexFromAllMessages(int index) {
    allMessages.removeAt(index);
  }

  void updateAllMessagesAtIndex(
    int index,
    MessageStruct Function(MessageStruct) updateFn,
  ) {
    allMessages[index] = updateFn(_allMessages[index]);
  }

  void insertAtIndexInAllMessages(int index, MessageStruct value) {
    allMessages.insert(index, value);
  }

  int _totalMessages = 0;
  int get totalMessages => _totalMessages;
  set totalMessages(int value) {
    _totalMessages = value;
  }

  int _highMessages = 0;
  int get highMessages => _highMessages;
  set highMessages(int value) {
    _highMessages = value;
  }
}
