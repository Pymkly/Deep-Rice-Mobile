import 'dart:convert';
import 'dart:io';

import 'package:deepricemobile/utils/utils.dart';

import '../../../widgets/button/button_listener.dart';
import 'package:http/http.dart' as http;

class DiseaseScanListener extends ButtonListener {
  // final File? image;
  final List<File>? images;
  final Function(Map<String, dynamic>) onResultsReady;

  // DiseaseScanListener(this.image);
  DiseaseScanListener(this.images, {required this.onResultsReady});
  @override
  void onClick() {
    // if (image != null) {
    //   uploadImage(image!); // Appelle la fonction pour envoyer l'image
    // } else {
    //   print("Aucune image sélectionnée !");
    // }
    if (images != null && images!.isNotEmpty) {
      predictDisease(images!); // Appelle la fonction pour envoyer les images
    } else {
      print("Aucune image sélectionnée !");
    }
  }

  Future<void> predictDisease(List<File> imageFiles) async {
    var baseUrl = DeepFarmUtils.baseUrl();
    final url = Uri.parse("$baseUrl/disease-detection/images");
    try {
      // Prépare la requête multipart
      final request = http.MultipartRequest('POST', url);
      for (var imageFile in imageFiles) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files', // Doit correspondre au nom du paramètre attendu par FastAPI
            imageFile.path,
          ),
        );
      }

      // Envoyer la requête
      final response = await request.send();

      // Vérifie la réponse
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = jsonDecode(responseBody);
        print("Réponse du serveur : $parsedResponse");
        onResultsReady(parsedResponse); // Met à jour l'état avec les résultats
      } else {
        print("Erreur lors de l'envoi : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

  // Future<void> uploadImage(File imageFile) async {
  Future<void> uploadImages(List<File> imageFiles) async {
    final url = Uri.parse("http://10.98.125.207:8000/upload-images/");
    try {
      // Prépare la requête multipart
      final request = http.MultipartRequest('POST', url);
      for (var imageFile in imageFiles) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files', // Doit correspondre au nom du paramètre attendu par FastAPI
            imageFile.path,
          ),
        );
      }

      // Envoyer la requête
      final response = await request.send();

      // Vérifie la réponse
      if (response.statusCode == 200) {
        print("Image envoyée avec succès !");
        final responseBody = await response.stream.bytesToString();
        print("Réponse du serveur : $responseBody");
      } else {
        print("Erreur lors de l'envoi : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

  Future<void> testApi() async {
    // Remplace '192.168.1.100' par l'IP de ton ordinateur
    final url = Uri.parse('http://10.98.125.207:8000/ping');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Response from API: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to connect to the server: $e');
    }
  }

}