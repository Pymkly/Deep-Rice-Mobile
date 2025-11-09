import 'package:flutter/material.dart';
import '../../../models/water/prediction_model.dart';

/// Widget displaying a prediction card
class PredictionCard extends StatelessWidget {
  final PredictionModel prediction;
  final String fieldName;
  final bool showFieldName;

  const PredictionCard({
    super.key,
    required this.prediction,
    required this.fieldName,
    this.showFieldName = true,
  });

  Color _getLevelColor() {
    if (prediction.predictedWaterNeed < 3.0) return Colors.green;
    if (prediction.predictedWaterNeed < 6.0) return Colors.orange;
    if (prediction.predictedWaterNeed < 10.0) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _getLevelIcon() {
    if (prediction.predictedWaterNeed < 3.0) return Icons.water_drop_outlined;
    if (prediction.predictedWaterNeed < 6.0) return Icons.water_drop;
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor();
    
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(_getLevelIcon(), color: color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showFieldName)
                          Text(
                            fieldName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        // ⬇️ CORRIGÉ : Utiliser formattedForecastDate au lieu de formattedDate
                        Text(
                          prediction.formattedForecastDate,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: color.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Text(
                  //     prediction.recommendationLevel,
                  //     style: TextStyle(
                  //       color: color,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 12,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),

              // Water need
              Row(
                children: [
                  Icon(Icons.water, size: 20, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    '${prediction.predictedWaterNeed.toStringAsFixed(1)} mm/jour',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Additional info - AJOUT des nouveaux champs météo
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           child: _buildInfoChip(
              //             icon: Icons.local_drink,
              //             label: '${prediction.getWaterNeedInLitersPerHectare().toStringAsFixed(0)} L/ha',
              //           ),
              //         ),
              //         const SizedBox(width: 8),
              //         if (prediction.confidence != null)
              //           Expanded(
              //             child: _buildInfoChip(
              //               icon: Icons.insights,
              //               label: 'Confiance: ${prediction.confidencePercentage}',
              //             ),
              //           ),
              //       ],
              //     ),
              //     const SizedBox(height: 8),
                  
              //     // ⬇️ NOUVEAUX : Informations météo supplémentaires
              //     if (prediction.temperatureCelsius != null || 
              //         prediction.rainfallMm != null)
              //       Row(
              //         children: [
              //           if (prediction.temperatureCelsius != null)
              //             Expanded(
              //               child: _buildInfoChip(
              //                 icon: Icons.thermostat,
              //                 label: '${prediction.temperatureCelsius!.toStringAsFixed(1)}°C',
              //               ),
              //             ),
              //           if (prediction.rainfallMm != null) ...[
              //             const SizedBox(width: 8),
              //             Expanded(
              //               child: _buildInfoChip(
              //                 icon: Icons.cloud,
              //                 label: '${prediction.rainfallMm!.toStringAsFixed(1)}mm pluie',
              //               ),
              //             ),
              //           ],
              //         ],
              //       ),
              //   ],
              // ),
              
              // Status indicator - ⬇️ CORRIGÉ : utilise maintenant forecastDate
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    prediction.isToday
                        ? Icons.today
                        : prediction.isPast
                            ? Icons.history
                            : Icons.schedule,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    prediction.isToday
                        ? 'Aujourd\'hui'
                        : prediction.isPast
                            ? 'Passé'
                            : 'À venir',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  // ⬇️ Optionnel : Afficher la date de prédiction
                  if (prediction.predictionDate != prediction.forecastDate) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Prédit le ${_formatDate(prediction.predictionDate)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⬇️ Helper pour formater les dates
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}