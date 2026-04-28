// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageStruct extends BaseStruct {
  MessageStruct({
    String? id,
    String? text,
    String? priority,
    int? hops,
    int? maxHops,
  })  : _id = id,
        _text = text,
        _priority = priority,
        _hops = hops,
        _maxHops = maxHops;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "priority" field.
  String? _priority;
  String get priority => _priority ?? '';
  set priority(String? val) => _priority = val;

  bool hasPriority() => _priority != null;

  // "hops" field.
  int? _hops;
  int get hops => _hops ?? 0;
  set hops(int? val) => _hops = val;

  void incrementHops(int amount) => hops = hops + amount;

  bool hasHops() => _hops != null;

  // "max_hops" field.
  int? _maxHops;
  int get maxHops => _maxHops ?? 0;
  set maxHops(int? val) => _maxHops = val;

  void incrementMaxHops(int amount) => maxHops = maxHops + amount;

  bool hasMaxHops() => _maxHops != null;

  static MessageStruct fromMap(Map<String, dynamic> data) => MessageStruct(
        id: data['id'] as String?,
        text: data['text'] as String?,
        priority: data['priority'] as String?,
        hops: castToType<int>(data['hops']),
        maxHops: castToType<int>(data['max_hops']),
      );

  static MessageStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'text': _text,
        'priority': _priority,
        'hops': _hops,
        'max_hops': _maxHops,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'priority': serializeParam(
          _priority,
          ParamType.String,
        ),
        'hops': serializeParam(
          _hops,
          ParamType.int,
        ),
        'max_hops': serializeParam(
          _maxHops,
          ParamType.int,
        ),
      }.withoutNulls;

  static MessageStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        priority: deserializeParam(
          data['priority'],
          ParamType.String,
          false,
        ),
        hops: deserializeParam(
          data['hops'],
          ParamType.int,
          false,
        ),
        maxHops: deserializeParam(
          data['max_hops'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'MessageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageStruct &&
        id == other.id &&
        text == other.text &&
        priority == other.priority &&
        hops == other.hops &&
        maxHops == other.maxHops;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, text, priority, hops, maxHops]);
}

MessageStruct createMessageStruct({
  String? id,
  String? text,
  String? priority,
  int? hops,
  int? maxHops,
}) =>
    MessageStruct(
      id: id,
      text: text,
      priority: priority,
      hops: hops,
      maxHops: maxHops,
    );
