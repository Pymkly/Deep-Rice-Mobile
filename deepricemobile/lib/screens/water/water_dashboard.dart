import 'package:flutter/material.dart';
import '../../services/water_api_service.dart';
import '../../models/water/field_model.dart';
import '../../models/water/prediction_model.dart';
import 'field_list_screen.dart';
import 'field_detail_screen.dart'; // ✅ Import
import 'all_predictions_screen.dart'; // ✅ Nouveau screen
import 'widgets/prediction_card.dart';
import 'widgets/stats_card.dart';

/// Water Management Dashboard
class WaterDashboard extends StatefulWidget {
  const WaterDashboard({super.key});

  @override
  State<WaterDashboard> createState() => _WaterDashboardState();
}

class _WaterDashboardState extends State<WaterDashboard> {
  final WaterApiService _api = WaterApiService();

  List<FieldModel> _fields = [];
  List<PredictionModel> _recentPredictions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load all fields
      final fields = await _api.getAllFields();

      // Load predictions for the first field (or all fields)
      List<PredictionModel> allPredictions = [];
      if (fields.isNotEmpty) {
        for (var field in fields.take(4)) {
          if (field.id != null) { // ✅ Utilise field.id au lieu de fieldId
            try {
              final predictions = await _api.getPredictionsByField(field.id!);
              allPredictions.addAll(predictions);
            } catch (e) {
              print('Error loading predictions for field ${field.id}: $e');
            }
          } else {
            print('Skipping field ${field.name} - id is null');
          }
        }
        
        // Sort by date descending
        allPredictions
            .sort((a, b) => b.predictionDate.compareTo(a.predictionDate));
      }

      setState(() {
        _fields = fields;
        _recentPredictions = allPredictions.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  double _calculateTotalArea() {
    return _fields.fold(0.0, (sum, field) => sum + (field.area ?? 0.0));
  }

  double _calculateAverageWaterNeed() {
    if (_recentPredictions.isEmpty) return 0.0;
    final total = _recentPredictions.fold(
      0.0,
      (sum, pred) => sum + pred.predictedWaterNeed,
    );
    return total / _recentPredictions.length;
  }

  // ✅ NOUVEAU : Trouver le field associé à une prédiction
  FieldModel? _findFieldForPrediction(PredictionModel prediction) {
    try {
      return _fields.firstWhere(
        (f) => f.id.toString() == prediction.fieldId.toString(),
      );
    } catch (e) {
      return null;
    }
  }

  // ✅ NOUVEAU : Navigation vers le détail du champ (onglet prédictions)
  void _navigateToFieldDetail(PredictionModel prediction) {
    final field = _findFieldForPrediction(prediction);
    
    if (field != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FieldDetailScreen(field: field),
        ),
      ).then((_) => _loadDashboardData());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Champ non trouvé'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de l\'Eau'),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _buildDashboardContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FieldListScreen()),
          ).then((_) => _loadDashboardData());
        },
        icon: const Icon(Icons.list),
        label: const Text('Voir tous les champs'),
        backgroundColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (_fields.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Aucun champ enregistré',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Commencez par ajouter un champ'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FieldListScreen()),
                ).then((_) => _loadDashboardData());
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un champ'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Champs',
                    value: '${_fields.length}',
                    icon: Icons.grid_on,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Surface totale',
                    value: '${_calculateTotalArea().toStringAsFixed(1)} ha',
                    icon: Icons.terrain,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StatsCard(
              title: 'Besoin moyen en eau',
              value:
                  '${_calculateAverageWaterNeed().toStringAsFixed(1)} mm/jour',
              icon: Icons.water_drop,
              color: Colors.blue,
            ),

            const SizedBox(height: 32),

            // Recent Predictions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Prédictions récentes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  // ✅ CORRIGÉ : Navigation vers toutes les prédictions
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllPredictionsScreen(
                          fields: _fields,
                        ),
                      ),
                    ).then((_) => _loadDashboardData());
                  },
                  child: const Text('Voir tout'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_recentPredictions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Aucune prédiction disponible',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ..._recentPredictions.map((prediction) {
                final field = _findFieldForPrediction(prediction);
                
                // ✅ CORRIGÉ : Carte cliquable
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _navigateToFieldDetail(prediction),
                    child: PredictionCard(
                      prediction: prediction,
                      fieldName: field?.name ?? 'Champ inconnu',
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}