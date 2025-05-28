import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/utils.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';


class MonitoringSection extends StatefulWidget {
  final int potoId;
  const MonitoringSection({super.key, required this.potoId});

  @override
  State<MonitoringSection> createState() => _MonitoringSectionState();
}

class _MonitoringSectionState extends State<MonitoringSection> {
  late IOWebSocketChannel _channel;

  Map<String, dynamic> _sensorData = {
    "DHT22": {"humidity": "--", "temperature": "--"},
    "NPK": {"N": "--", "P": "--", "K": "--"},
  };

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect(
        'ws://${DeepFarmUtils.ipServer()}/ws/monitoring?id=${widget.potoId}'
    );
    _channel.stream.listen((data) {
      setState(() {
        _sensorData = json.decode(data);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre Monitoring
          Text("Monitoring",
            style: GoogleFonts.nunito(
                fontSize: DeepFarmUtils.extractDoubleConfig("SLOGAN_FS")
            ),
          ),
          const SizedBox(height: 10),

          // Deux colonnes (DHT22Sensor & NPK)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SensorCard(
                title: "DHT22",
                data: [
                  {"label": "Humidity", "value": _sensorData["DHT22"]["humidity"]},
                  {"label": "Temperature", "value": _sensorData["DHT22"]["temperature"]},
                ],
              ),
              const SizedBox(width: 20),
              _SensorCard(
                title: "NPK",
                data: [
                  {"label": "N", "value": _sensorData["NPK"]["N"]},
                  {"label": "P", "value": _sensorData["NPK"]["P"]},
                  {"label": "K", "value": _sensorData["NPK"]["K"]},
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bouton Voir Plus
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/monitoring'); // Redirige vers la page de monitoring détaillée
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Voir plus",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  const _SensorCard({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 1),

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
                style: GoogleFonts.nunito(
                  fontSize: 18.6,
                  fontWeight: FontWeight.w800,
                )
            ),
            ...data.map((item) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['label'], style: const TextStyle(fontWeight: FontWeight.w500)),
                item['value'] is IconData
                    ? Icon(item['value'], color: Colors.green.shade700, size: 24) // Icône comme valeur
                    : Text(item['value'].toString()), // Texte classique
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }
}