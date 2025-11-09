import 'package:flutter/material.dart';
import '../../services/water_api_service.dart';
import '../../models/water/field_model.dart';
import '../../models/water/prediction_model.dart';
import '../../models/water/sensor_data_model.dart';
import 'widgets/prediction_card.dart';
import 'widgets/water_chart.dart';

/// Screen showing details of a specific field
class FieldDetailScreen extends StatefulWidget {
  final FieldModel field;

  const FieldDetailScreen({super.key, required this.field});

  @override
  State<FieldDetailScreen> createState() => _FieldDetailScreenState();
}

class _FieldDetailScreenState extends State<FieldDetailScreen>
    with SingleTickerProviderStateMixin {
  final WaterApiService _api = WaterApiService();

  late TabController _tabController;
  List<PredictionModel> _predictions = [];
  List<SensorDataModel> _sensorData = [];
  List<Map<String, dynamic>> _recommendations = []; // ✅ Liste de recommandations
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // ✅ 4 onglets maintenant
    _loadFieldData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFieldData() async {
    if (widget.field.id == null) {
      setState(() {
        _errorMessage = 'ID du champ non disponible';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final predictions = await _api.getPredictionsByField(widget.field.id!);
      predictions.sort((a, b) => b.predictionDate.compareTo(a.predictionDate));

      List<SensorDataModel> sensorData = [];
      try {
        sensorData = await _api.getSensorDataByField(widget.field.id!);
        sensorData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      } catch (e) {
        print('No sensor data available: $e');
      }

      // ✅ Récupérer les recommandations dynamiques (7 jours)
      List<Map<String, dynamic>> recommendations = [];
      try {
        final recResponse = await _api.getRecommendations(widget.field.id!);
        
        // Si c'est une liste
        if (recResponse is List) {
          recommendations = List<Map<String, dynamic>>.from(recResponse as Iterable);
        } 
        // Si c'est un objet unique, le convertir en liste
        else if (recResponse is Map<String, dynamic>) {
          recommendations = [recResponse];
        }
        
        print('✅ Loaded ${recommendations.length} recommendations');
      } catch (e) {
        print('⚠️ No recommendations available: $e');
      }

      setState(() {
        _predictions = predictions;
        _sensorData = sensorData;
        _recommendations = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateNewPrediction() async {
    if (widget.field.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID du champ non disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await _api.generatePrediction(
        fieldId: widget.field.id!,
        predictionDate: DateTime.now().add(const Duration(days: 1)),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nouvelle prédiction générée'),
            backgroundColor: Colors.green,
          ),
        );
        _loadFieldData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.field.name ?? 'Default name'),
        backgroundColor: Colors.blue[700],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // ✅ Permet le scroll si 4 onglets
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Infos'),
            Tab(icon: Icon(Icons.trending_up), text: 'Prédictions'),
            Tab(icon: Icon(Icons.recommend), text: 'Recommandations'), // ✅ NOUVEAU
            Tab(icon: Icon(Icons.sensors), text: 'Capteurs'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFieldData,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInfoTab(),
                    _buildPredictionsTab(),
                    _buildRecommendationsTab(), // ✅ NOUVEAU
                    _buildSensorDataTab(),
                  ],
                ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _generateNewPrediction,
              icon: const Icon(Icons.psychology),
              label: const Text('Nouvelle prédiction'),
              backgroundColor: Colors.blue[700],
            )
          : null,
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
            onPressed: _loadFieldData,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return RefreshIndicator(
      onRefresh: _loadFieldData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.grid_on, 'Nom', widget.field.name ?? 'Default Nom'),
                    const Divider(),
                    _buildInfoRow(Icons.location_on, 'Localisation',
                        widget.field.location ?? 'Default localisation'),
                    const Divider(),
                    _buildInfoRow(Icons.terrain, 'Surface',
                        '${widget.field.area} hectares'),
                    if (widget.field.cropType != null) ...[
                      const Divider(),
                      _buildInfoRow(
                          Icons.grass, 'Culture', widget.field.cropType!),
                    ],
                    if (widget.field.plantingDate != null) ...[
                      const Divider(),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Date de plantation',
                        '${widget.field.plantingDate!.day}/${widget.field.plantingDate!.month}/${widget.field.plantingDate!.year}',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // ✅ Résumé des recommandations dans l'onglet Info
            if (_recommendations.isNotEmpty) ...[
              const Text(
                'Recommandation du jour',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildQuickRecommendationSummary(_recommendations.first),
            ],
          ],
        ),
      ),
    );
  }

  // ✅ NOUVEAU : Résumé rapide de la recommandation du jour
  Widget _buildQuickRecommendationSummary(Map<String, dynamic> rec) {
    final shouldIrrigate = rec['should_irrigate'] == true;
    final waterAmount = rec['water_amount_mm'] ?? 0;
    final priority = rec['priority'] ?? 'medium';

    return Card(
      elevation: 3,
      color: shouldIrrigate ? Colors.blue.shade50 : Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              shouldIrrigate ? Icons.water_drop : Icons.check_circle,
              size: 40,
              color: shouldIrrigate ? Colors.blue : Colors.green,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shouldIrrigate ? 'Irrigation recommandée' : 'Pas d\'irrigation nécessaire',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: shouldIrrigate ? Colors.blue.shade800 : Colors.green.shade800,
                    ),
                  ),
                  if (shouldIrrigate) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$waterAmount mm • Priorité: ${_getPriorityLabel(priority)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
            _buildPriorityBadge(priority),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsTab() {
    return RefreshIndicator(
      onRefresh: _loadFieldData,
      child: _predictions.isEmpty
          ? const Center(
              child: Text('Aucune prédiction disponible'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_predictions.isNotEmpty)
                  WaterChart(predictions: _predictions.take(7).toList()),
                const SizedBox(height: 24),
                const Text(
                  'Historique des prédictions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._predictions.map((prediction) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PredictionCard(
                        prediction: prediction,
                        fieldName: widget.field.name ?? 'Default name',
                        showFieldName: false,
                      ),
                    )),
              ],
            ),
    );
  }

  // ✅ NOUVEAU : Onglet Recommandations dynamiques
  Widget _buildRecommendationsTab() {
    return RefreshIndicator(
      onRefresh: _loadFieldData,
      child: _recommendations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recommend_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucune recommandation disponible',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadFieldData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualiser'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Recommandations pour les ${_recommendations.length} prochains jours',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ..._recommendations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rec = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildDynamicRecommendationCard(rec, index),
                  );
                }),
              ],
            ),
    );
  }

  // ✅ Carte de recommandation dynamique
  Widget _buildDynamicRecommendationCard(Map<String, dynamic> rec, int dayIndex) {
    final shouldIrrigate = rec['should_irrigate'] == true;
    final waterAmount = rec['water_amount_mm'] ?? 0;
    final timing = rec['timing'] ?? 'morning';
    final reason = rec['reason'] ?? 'Raison non disponible';
    final priority = rec['priority'] ?? 'medium';
    
    // Calculer la date
    final recDate = DateTime.now().add(Duration(days: dayIndex));
    final dateLabel = dayIndex == 0 
        ? 'Aujourd\'hui' 
        : dayIndex == 1 
            ? 'Demain' 
            : '${recDate.day}/${recDate.month}/${recDate.year}';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: shouldIrrigate
                ? [Colors.blue.shade50, Colors.lightBlue.shade50]
                : [Colors.green.shade50, Colors.lightGreen.shade50],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: shouldIrrigate ? Colors.blue : Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      shouldIrrigate ? Icons.water_drop : Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateLabel,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          shouldIrrigate ? 'IRRIGATION REQUISE' : 'PAS D\'IRRIGATION',
                          style: TextStyle(
                            fontSize: 12,
                            color: shouldIrrigate ? Colors.blue.shade700 : Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPriorityBadge(priority),
                ],
              ),
              const SizedBox(height: 16),

              // Détails
              if (shouldIrrigate) ...[
                _buildRecommendationItem(
                  icon: Icons.opacity,
                  label: 'Quantité d\'eau',
                  value: '$waterAmount mm',
                  color: Colors.blue.shade700,
                ),
                const SizedBox(height: 8),
                _buildRecommendationItem(
                  icon: Icons.access_time,
                  label: 'Meilleur moment',
                  value: _formatTiming(timing),
                  color: Colors.orange.shade700,
                ),
                const SizedBox(height: 8),
              ],
              
              _buildRecommendationItem(
                icon: Icons.lightbulb_outline,
                label: 'Raison',
                value: reason,
                color: Colors.grey.shade700,
              ),
              
              // Volume
              if (shouldIrrigate && waterAmount > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calculate, size: 18, color: Colors.blue.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Volume: ${_calculateWaterVolume(waterAmount)} L pour ${widget.field.area ?? 0} ha',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    final priorityColors = {
      'low': Colors.green,
      'medium': Colors.orange,
      'high': Colors.red,
      'critical': Colors.deepOrange,
    };
    
    final color = priorityColors[priority] ?? Colors.grey;
    final label = _getPriorityLabel(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _getPriorityLabel(String priority) {
    const labels = {
      'low': 'Basse',
      'medium': 'Moyenne',
      'high': 'Haute',
      'critical': 'Critique',
    };
    return labels[priority] ?? 'Inconnue';
  }

  Widget _buildRecommendationItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTiming(String timing) {
    const timingMap = {
      'morning': 'Matin',
      'afternoon': 'Après-midi',
      'evening': 'Soir',
      'night': 'Nuit',
    };
    return timingMap[timing] ?? timing;
  }

  String _calculateWaterVolume(double waterAmountMm) {
    final area = widget.field.area ?? 0;
    final volume = waterAmountMm * area * 10000;
    return volume.toStringAsFixed(0);
  }

  Widget _buildSensorDataTab() {
    return RefreshIndicator(
      onRefresh: _loadFieldData,
      child: _sensorData.isEmpty
          ? const Center(
              child: Text('Aucune donnée capteur disponible'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sensorData.length,
              itemBuilder: (context, index) {
                final data = _sensorData[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.formattedTimestamp,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSensorValue(
                                'Humidité sol',
                                '${data.moisturePercent?.toStringAsFixed(1) ?? 'N/A'}%',
                                Icons.opacity,
                              ),
                            ),
                            Expanded(
                              child: _buildSensorValue(
                                'Température',
                                '${data.soilTemperatureCelsius?.toStringAsFixed(1) ?? 'N/A'}°C',
                                Icons.thermostat,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSensorValue(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}