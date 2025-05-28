import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService extends StatefulWidget {
  const WebSocketService({super.key});

  @override
  _WebSocketServiceState createState() => _WebSocketServiceState();
}

class _WebSocketServiceState extends State<WebSocketService> {
  final _channel = IOWebSocketChannel.connect('ws://<IP_DU_SERVEUR>:8000/ws/sensor-data');

  String _sensorData = "En attente des données...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoring en temps réel')),
      body: Center(
        child: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              _sensorData = snapshot.hasData ? snapshot.data.toString() : "Aucune donnée reçue";
            }

            return Text(
              _sensorData,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Ferme la connexion WebSocket proprement
    super.dispose();
  }
}
