// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HealthResponseStruct extends BaseStruct {
  HealthResponseStruct({
    String? status,
    String? detail,
  })  : _status = status,
        _detail = detail;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "detail" field.
  String? _detail;
  String get detail => _detail ?? '';
  set detail(String? val) => _detail = val;

  bool hasDetail() => _detail != null;

  static HealthResponseStruct fromMap(Map<String, dynamic> data) =>
      HealthResponseStruct(
        status: data['status'] as String?,
        detail: data['detail'] as String?,
      );

  static HealthResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? HealthResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'status': _status,
        'detail': _detail,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'detail': serializeParam(
          _detail,
          ParamType.String,
        ),
      }.withoutNulls;

  static HealthResponseStruct fromSerializableMap(Map<String, dynamic> data) =>
      HealthResponseStruct(
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        detail: deserializeParam(
          data['detail'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'HealthResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HealthResponseStruct &&
        status == other.status &&
        detail == other.detail;
  }

  @override
  int get hashCode => const ListEquality().hash([status, detail]);
}

HealthResponseStruct createHealthResponseStruct({
  String? status,
  String? detail,
}) =>
    HealthResponseStruct(
      status: status,
      detail: detail,
    );
