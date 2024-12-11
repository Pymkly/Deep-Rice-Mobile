import 'package:deepricemobile/screens/home/disease_classification/disease_classification_screen.dart';
import 'package:deepricemobile/screens/home/header/main_header.dart';
import 'package:deepricemobile/screens/home/landing/landing_page.dart';
import 'package:deepricemobile/screens/home/menu/main_menu.dart';
import 'package:deepricemobile/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'footer/main_footer.dart';

class HomeScreen extends MainScreen {
  HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenStateManager();
}

class _HomeScreenStateManager extends State<HomeScreen> {
  late int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = const [
      LandingPage(),
      MainMenu(),
      DiseaseClassificationScreen()
    ];
    MainFooter mainFooter = prepareFooter();
    return Scaffold(
      appBar: const MainHeader(),
      body: SingleChildScrollView(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: mainFooter.build()
    );
  }

  MainFooter prepareFooter() {
    MainFooter mainFooter = MainFooter(currentIndex, (index) {
      setState(() {
        currentIndex = index;
      });
    }, [
      BottomNavItem(
        icon: Icons.home,
        label: 'Home',
      ),
      BottomNavItem(
        icon: Icons.person,
        label: 'User',
      )
    ]);
    return mainFooter;
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {

    _currentIndex = index;
  }

}