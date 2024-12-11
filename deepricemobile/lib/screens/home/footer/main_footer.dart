import 'dart:core';

import 'package:deepricemobile/widgets/printable_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainFooter implements PrintableWidget{
  int _index = 0;
  late Function _callback;
  late List<BottomNavigationBarItem> _widgets;
  late List<BottomNavItem> _links;


  MainFooter(int indexParam, Function callback, List<BottomNavItem> links) {
    index = indexParam;
    _callback = callback;
    this.links = links;
  }

  @override
  Widget build() {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: Colors.blue, // Couleur de l'élément sélectionné
      unselectedItemColor: Colors.grey, // Couleur des éléments non sélectionnés
      onTap: (index) {
        _callback(index);
      },
      items: widgets,
    );
  }

  List<BottomNavItem> get links => _links;

  set links(List<BottomNavItem> linksParam) {
    _links = linksParam;
    widgets = toLinks(linksParam);
  }

  List<BottomNavigationBarItem> toLinks(List<BottomNavItem> linksParam) {
    return linksParam
        .map(
          (item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label
      ),
    ).toList();
  }

  List<BottomNavigationBarItem> get widgets => _widgets;

  set widgets(List<BottomNavigationBarItem> widgets) {
    _widgets = widgets;
  }

  int get index => _index;

  set index(int value) {
    if (value < 0) {
      if (kDebugMode) {
        print("Value not permitted");
      }
    }
    _index = value;
  }

}

class BottomNavItem {
  late IconData icon;
  late String label;

  BottomNavItem({
    required this.icon,
    required this.label
  });
}
