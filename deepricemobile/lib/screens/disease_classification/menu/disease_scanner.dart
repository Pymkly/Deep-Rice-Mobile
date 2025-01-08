import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../../../widgets/button/margin_button.dart';
import '../../../widgets/custom_image_picker/custom_image_picker.dart';
import '../../home/landing/service_component.dart';
import 'disease_scan_listner.dart';

class DiseaseScanner extends StatefulWidget{
  const DiseaseScanner({super.key});

  @override
  State<StatefulWidget> createState() => _DiseaseScannerState();
}

class _DiseaseScannerState extends State<DiseaseScanner> {
  @override
  Widget build(BuildContext context) {
    Map service = {
      'title': 'Disease detection',
      'link' : '/disease-detection',
      'illustration' : 'images/landing/services/disease-detection.jpg',
      'shortDescription' : 'Disease classification identifies and categorizes plant diseases to improve diagnosis and treatment. It helps farmers protect crops effectively.'
    };
    ServiceInfo info = ServiceInfo(service['illustration'], service['shortDescription'], service['link'], service['title']);
    return Column(
      children: [
        Column(
          children: [
            ServiceImageSection(info, isDetail: true,),
            const SizedBox(height: 30,),
            ServiceDetailsSection(info, isDetail: true,),
            DiseaseImagePickerSection()
          ],
        )
      ],
    );
  }
}

class DiseaseImagePickerSection extends StatefulWidget {
  @override
  _DiseaseImagePickerSectionState createState() => _DiseaseImagePickerSectionState();
}

class _DiseaseImagePickerSectionState extends State<DiseaseImagePickerSection> {
  Map<String, dynamic>? _predictionResults;
  List<File>? _selectedImages;
  void _onImagesPicked(List<File>? images) {
    setState(() {
      _selectedImages = images;
    });
  }
  void _updatePredictionResults(Map<String, dynamic> results) {
    setState(() {
      _predictionResults = results;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
            const SizedBox(width: 20),
              Expanded(
                  child: Text("Select or Capture an Image", style: GoogleFonts.nunito(
                      fontSize: 18.6,
                      fontWeight: FontWeight.w800,
                      color: DeepFarmUtils.greenColor
                  ))
              )
            ]
          ),
          // ImagePickerScreen(onImagePicked: _onImagePicked),
          ImagePickerScreen(onImagesPicked: _onImagesPicked),
          Container(
            // margin: EdgeInsets.only(left: 0),
            child: Row(
              children: [
                CustomMarginButton(
                    "Analyze Image",
                  // DiseaseScanListener(_selectedImage)
                  DiseaseScanListener(
                      _selectedImages,
                    onResultsReady: _updatePredictionResults,
                  )
                ).build()
              ],
            ),
          ),
          if (_predictionResults != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Analysis Results",
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: DeepFarmUtils.greenColor,
                  ),
                ),
              )
              ]
            ),
            SizedBox(height: 10),
            _buildPredictionResults(),
            SizedBox(height: 40),
          ],
        ],
      ),
    );
  }
  Widget _buildPredictionResults() {
    final results = _predictionResults!["individual_results"] as List;
    return Column(
      children: results.map((result) {
        final predictedClass = result["predicted_class"];
        final probabilities = result["probabilities"] as List;
        final description = result["predicted_class_"]["description"];
        final instructions =result["predicted_class_"]["instructions"];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                      child: Text("Disease Detected: $predictedClass", style: GoogleFonts.nunito(
                          fontSize: 18.6,
                          fontWeight: FontWeight.w800,
                          color: DeepFarmUtils.greenColor
                      ))
                  )
                ]
            ),
            const SizedBox(height: 5),
            Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                      child: Text(description, style: GoogleFonts.nunito(
                        fontSize: 14.6,
                      ))
                  )
                ]
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                    child: Text("Instructions :", style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.6,
                    ))
                ),
                const SizedBox(width: 20)
              ],
            ),
            const SizedBox(height: 5),
            Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                      child: Text(instructions, style: GoogleFonts.nunito(
                        fontSize: 14.6,
                      ))
                  )
                ]
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Text("Probabilities :", style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                  fontSize: 16.6,
                  ))
                ),
                const SizedBox(width: 20)
              ],
            ),
            ...probabilities.asMap().entries.map((entry) {
              final index = entry.key;
              final probability = entry.value;

              // return Text("Class $index: ${(probability * 100).toStringAsFixed(2)}%");
              return Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                      child: Text("${probability['class']}: ${(probability['value'] * 100).toStringAsFixed(2)}%", style: GoogleFonts.nunito(
                        fontSize: 14.6,
                      ))
                  ),
                  const SizedBox(width: 20)
                ],
              );
            }),
            const SizedBox(height: 20)
            // const Divider(),
          ],
        );
      }).toList(),
    );
  }
}



