import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'setting_widget.dart' show SettingWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingModel extends FlutterFlowModel<SettingWidget> {
  ///  Local state fields for this page.

  bool isBackendOnline = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (health)] action in Setting widget.
  ApiCallResponse? apiResulttcr;
  // Stores action output result for [Backend Call - API (clear)] action in Container widget.
  ApiCallResponse? apiResulty59;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
