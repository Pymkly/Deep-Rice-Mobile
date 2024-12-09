import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma Première App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue dans Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrez votre nom',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Bouton cliqué!');
              },
              child: Text('Cliquez ici'),
            ),
          ],
        ),
      ),
    );
  }
}
