import 'package:deepricemobile/screens/home/header/main_header.dart';
import 'package:deepricemobile/screens/home/landing/landing_page.dart';
import 'package:deepricemobile/screens/main_screen.dart';
import 'package:flutter/material.dart';

import 'menu/disease_scanner.dart';

class DiseaseClassificationScreen extends MainScreen {
  DiseaseClassificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DiseaseClassificationScreenStateManager();
}

class _DiseaseClassificationScreenStateManager extends State<DiseaseClassificationScreen> {
  late int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainHeader(),
        body: SingleChildScrollView(
          child: DiseaseScanner(),
        )
    );
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {

    _currentIndex = index;
  }

}