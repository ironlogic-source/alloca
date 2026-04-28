import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navbar_model.dart';
export 'navbar_model.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  late NavbarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF191818),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 1.0,
            decoration: BoxDecoration(
              color: Color(0x29FFFFFF),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      FFAppState().selectedTab = 'home';
                      safeSetState(() {});

                      context.pushNamed(
                        ResourcepageWidget.routeName,
                        extra: <String, dynamic>{
                          '__transition_info__': TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: FFAppState().selectedTab == 'home'
                                ? Color(0x2DFFFFFF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 1.8, 10.0, 1.8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (FFAppState().selectedTab == 'home')
                                  Icon(
                                    FFIcons.khomeFill,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                if (FFAppState().selectedTab != 'home')
                                  Icon(
                                    FFIcons.khomeFill,
                                    color: Color(0xFF808080),
                                    size: 24.0,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Home',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FFAppState().selectedTab == 'home'
                                        ? Colors.white
                                        : Color(0xFF808080),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ].divide(SizedBox(height: 2.0)),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      // Action 1
                      HapticFeedback.lightImpact();
                      FFAppState().selectedTab = 'request';
                      safeSetState(() {});

                      context.pushNamed(
                        HelprequestpageWidget.routeName,
                        extra: <String, dynamic>{
                          '__transition_info__': TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: FFAppState().selectedTab == 'request'
                                ? Color(0x2DFFFFFF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 1.8, 10.0, 1.8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (FFAppState().selectedTab == 'request')
                                  Icon(
                                    Icons.sos,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                if (FFAppState().selectedTab != 'request')
                                  Icon(
                                    Icons.sos,
                                    color: Color(0xFF808080),
                                    size: 24.0,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Request',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FFAppState().selectedTab == 'request'
                                        ? Colors.white
                                        : Color(0xFF808080),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ].divide(SizedBox(height: 2.0)),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      FFAppState().selectedTab = 'dashboard';
                      safeSetState(() {});

                      context.pushNamed(
                        DashboardWidget.routeName,
                        extra: <String, dynamic>{
                          '__transition_info__': TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: FFAppState().selectedTab == 'dashboard'
                                ? Color(0x2DFFFFFF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 1.8, 10.0, 1.8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (FFAppState().selectedTab == 'dashboard')
                                  Icon(
                                    FFIcons.kscorecardLine,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                if (FFAppState().selectedTab != 'dashboard')
                                  Icon(
                                    FFIcons.kscorecardLine,
                                    color: Color(0xFF808080),
                                    size: 24.0,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Dashboard',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FFAppState().selectedTab == 'dashboard'
                                    ? Colors.white
                                    : Color(0xFF808080),
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ].divide(SizedBox(height: 2.0)),
                    ),
                  ),
                ),
              ].divide(SizedBox(width: 10.0)),
            ),
          ),
        ],
      ),
    );
  }
}
