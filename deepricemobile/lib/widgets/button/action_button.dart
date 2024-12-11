import 'package:deepricemobile/utils/utils.dart';
import 'package:deepricemobile/widgets/printable_widget.dart';
import 'package:flutter/material.dart';

import 'button_listener.dart';

abstract class ActionButton implements PrintableWidget {
  late String _label;
  late ButtonListener _listener;


  ActionButton(String label, ButtonListener callback) {
    this.label = label;
    this.replaceListener = callback;
  }

  @override
  Widget build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  set replaceListener(ButtonListener callback) {
    _listener = callback;
  }

  void call() {
    _listener.onClick();
  }

  static void defaultAction() {
    print("action not defined yet");
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }
}