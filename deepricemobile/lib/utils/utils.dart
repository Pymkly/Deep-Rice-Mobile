import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../widgets/button/button_listener.dart';

class DeepFarmUtils {
  static const double DEFAULT_MARGIN = 16.0;

  static String extractENV(String key, {String defaultValue = "Value"}) {
    return dotenv.env[key]?? defaultValue;
  }

  static double extractDoubleConfig(String key) {
    return double.parse(dotenv.env[key]?? '20');
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static addBorder(Widget widget, double margin) {
    return Container(
        margin: EdgeInsets.all(margin),
        child: widget
    );
  }

  static int extractIntConfig(String key) {
    return int.parse(dotenv.env[key]?? '20');
  }
}