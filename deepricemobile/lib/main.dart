import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma Première App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue dans Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prepareTextField("Nom de l'expérience"),
            const SizedBox(height: 20),
            prepareButton("Valider", validate)
          ],
        ),
      ),
    );
  }
}

void validate() {
  print("Le bouton a été cliqué");
}

Widget prepareTextField(String label, {double margin = 16.0}) {
  Widget response = TextField(
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label
    ),
  );
  response = addBorder(response, margin);
  return response;
}

Widget addBorder(Widget widget, double margin) {
  return Container(
    margin: EdgeInsets.all(margin),
    child: widget
  );
}

Widget prepareButton(String label, Function callback, {double margin = 16.0}) {
  Widget response = SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        callback();
      },
      child: Text(label),
    ),
  );
  response = addBorder(response, margin);
  return response;
}
