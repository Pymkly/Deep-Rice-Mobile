import 'package:deepricemobile/screens/home/header/main_header.dart';
import 'package:deepricemobile/screens/main_screen.dart';
import 'package:flutter/material.dart';

import 'menu/chat_page.dart';

// import 'menu/disease_scanner.dart';

class AgentScreen extends MainScreen {
  AgentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AgentScreenStateManager();
}

class _AgentScreenStateManager extends State<AgentScreen> {
  late int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainHeader(),
        body: SingleChildScrollView(
          child: ChatPage(),
        )
    );
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {

    _currentIndex = index;
  }

}