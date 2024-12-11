import 'package:deepricemobile/utils/utils.dart';
import 'package:flutter/material.dart';

abstract class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  static Widget verticalLayout(List<Widget> widgets) {
    return Column( // Alignement en colonne pour mobile
      children: widgets,
    );
  }

  static Widget horizontalLayout(List<Widget> widgets, {int size = -1}) {
    size = size < 0 ? widgets.length : size;
    return GridView.count(
      crossAxisCount: size,
      // Deux colonnes
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(10),
      children: widgets,
    );
  }

  static Widget responsiveWidget(BuildContext context, Widget mobile, Widget desktop) {
    if (DeepFarmUtils.isMobile(context)) {
      return mobile;
    }
    return desktop;
  }
}