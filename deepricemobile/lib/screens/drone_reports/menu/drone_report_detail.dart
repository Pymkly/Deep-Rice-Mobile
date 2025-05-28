import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../utils/utils.dart';
import '../../../widgets/button/margin_button.dart';
import '../../home/landing/service_component.dart';
import 'package:http/http.dart' as http;

class DroneReportDetail extends StatefulWidget{
  final int? reportId; // ID du rapport sélectionné
  final VoidCallback onBack;
  DroneReportDetail({required this.reportId, required this.onBack, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DroneReportDetailState();
}

class _DroneReportDetailState extends State<DroneReportDetail> {
  Map<String, dynamic>? droneReportData ={
    "report": {"images": []},
    "land": {
      "title": "",
      "boundary": [],
      "parcels": []
    }
  };

  @override
  void initState() {
    super.initState();
    fetchDroneReport();
  }

  Future<void> fetchDroneReport() async {
    try {
      var baseUrl = DeepFarmUtils.baseUrl();
      final url = '$baseUrl/drone-reports/${widget.reportId}'; // Remplacez par votre URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          droneReportData = jsonDecode(response.body); // Parse JSON
        });
      } else {
        print('Erreur : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.reportId);
    Map service = {
      'title': 'Drone Reports',
      'link' : '/disease-detection',
      'illustration' : 'images/landing/services/drone-reports.jpg',
      'shortDescription' : 'Drone reports capture high-resolution images of rice fields, analyze plant health, and detect diseases. The data is processed to identify infected areas and generate a map highlighting affected parcels, enabling precise and efficient interventions for farmers.'
    };
    ServiceInfo info = ServiceInfo(service['illustration'], service['shortDescription'], service['link'], service['title']);
    return Column(
      children: [
        Column(
          children: [
            // ServiceImageSection(info, isDetail: true,),
            const SizedBox(height: 30,),
            ServiceDetailsSection(info, isDetail: true,),
            // DiseaseImagePickerSection()
            SizedBox(
              height: 400, // Donnez une hauteur explicite à la carte
              child: MapScreen(
                parcels: droneReportData!["land"]["parcels"], // Passe les parcelles
                boundary: droneReportData!["land"]["boundary"],
                images: droneReportData!["report"]["images"],// Passe les limites globales
              ),
            ),
          ],
        )
      ],
    );
  }
}

class MapScreen extends StatelessWidget {
  final LatLng initialLocation = LatLng(-19.022337,  47.531865 );
  final LatLng markerLocation = LatLng(-19.022337,  47.531865);
  final List<dynamic> parcels; // Liste des parcelles
  final List<dynamic> boundary; // Limites globales du terrain
  final List<dynamic> images;

  MapScreen({required this.parcels, required this.boundary, required this.images});
  @override
  Widget build(BuildContext context) {
    // Convertir les limites globales en LatLng
    List<LatLng> boundaryPoints = boundary
        .map((coord) => LatLng(coord[1], coord[0])) // Inverser [long, lat] -> [lat, long]
        .toList();

    // Convertir les parcelles en objets Polygon
    List<Polygon> parcelPolygons = parcels.map((parcel) {
      List<LatLng> points = (parcel["boundary"] as List)
          .map((coord) => LatLng(coord[1], coord[0]))
          .toList();
      return Polygon(
        points: points,
        color: Colors.green.withOpacity(0.3),
        borderColor: Colors.green,
        borderStrokeWidth: 2.0,
      );
    }).toList();
    parcelPolygons.add(
      Polygon(
        points: boundaryPoints,
        color: Colors.blue.withOpacity(0.1),
        borderColor: Colors.blue,
        borderStrokeWidth: 3.0,
      ),
    );
    List<Marker> imageMarkers = images.map((image) {
      final location = image["location"];
      final LatLng point = LatLng(location["latitude"], location["longitude"]);
      final String imageClass = image["class"]; // Par exemple "Brownspot", "Blast", etc.
      final String probability = (image["probability"] * 100).toStringAsFixed(1); // Probabilité en pourcentage
      return Marker(
        width: 150.0,
        height: 80.0,
        point: point,
        builder: (ctx) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "$imageClass ($probability%)",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const Icon(
              Icons.camera_alt,
              color: Colors.red,
              size: 30,
            ),
          ],
        ),
      );
    }).toList();
    return FlutterMap(
        options: MapOptions(
          center: initialLocation, // Latitude/Longitude (Paris, France)
          zoom: 17.0,
        ),
        children: [
          TileLayer(
            // urlTemplate:
            // "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            urlTemplate: "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
            subdomains: ['a', 'b', 'c']
          ),
          MarkerLayer(
            markers: imageMarkers,
          ),
          PolygonLayer(
            polygons: parcelPolygons,
          ),
        ],
      );
  }
}