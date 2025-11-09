import 'package:flutter/material.dart';
import '../../services/water_api_service.dart';
import '../../models/water/field_model.dart';
import '../../models/water/prediction_model.dart';
import 'field_detail_screen.dart';

/// Screen showing all predictions across all fields with modern grid layout
class AllPredictionsScreen extends StatefulWidget {
  final List<FieldModel> fields;

  const AllPredictionsScreen({
    super.key,
    required this.fields,
  });

  @override
  State<AllPredictionsScreen> createState() => _AllPredictionsScreenState();
}

class _AllPredictionsScreenState extends State<AllPredictionsScreen> {
  final WaterApiService _api = WaterApiService();

  List<PredictionModel> _allPredictions = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _sortBy = 'date'; // 'date' ou 'field'
  String _viewMode = 'grid'; // 'grid' ou 'list'

  @override
  void initState() {
    super.initState();
    _loadAllPredictions();
  }

  Future<void> _loadAllPredictions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<PredictionModel> allPredictions = [];

      for (var field in widget.fields) {
        if (field.id != null) {
          try {
            final predictions = await _api.getPredictionsByField(field.id!);
            allPredictions.addAll(predictions);
          } catch (e) {
            print('Error loading predictions for field ${field.id}: $e');
          }
        }
      }

      allPredictions.sort((a, b) => b.predictionDate.compareTo(a.predictionDate));

      setState(() {
        _allPredictions = allPredictions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  void _sortPredictions() {
    setState(() {
      if (_sortBy == 'date') {
        _allPredictions.sort((a, b) => b.predictionDate.compareTo(a.predictionDate));
      } else {
        _allPredictions.sort((a, b) => a.fieldId.compareTo(b.fieldId));
      }
    });
  }

  FieldModel? _findFieldForPrediction(PredictionModel prediction) {
    try {
      return widget.fields.firstWhere(
        (f) => f.id.toString() == prediction.fieldId.toString(),
      );
    } catch (e) {
      return null;
    }
  }

  void _navigateToFieldDetail(PredictionModel prediction) {
    final field = _findFieldForPrediction(prediction);
    
    if (field != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FieldDetailScreen(field: field),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les Prédictions'),
        backgroundColor: Colors.blue[700],
        actions: [
          // Toggle vue grille/liste
          IconButton(
            icon: Icon(_viewMode == 'grid' ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == 'grid' ? 'list' : 'grid';
              });
            },
            tooltip: _viewMode == 'grid' ? 'Vue liste' : 'Vue grille',
          ),
          // Bouton de tri
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _sortPredictions();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: _sortBy == 'date' ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    const Text('Trier par date'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'field',
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_on,
                      size: 20,
                      color: _sortBy == 'field' ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    const Text('Trier par champ'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllPredictions,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _buildContent(),
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
            onPressed: _loadAllPredictions,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_allPredictions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Aucune prédiction disponible',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Générez des prédictions depuis les fiches des champs'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAllPredictions,
      child: Column(
        children: [
          // Header avec statistiques
          _buildHeader(),
          
          // Grille ou liste de prédictions
          Expanded(
            child: _viewMode == 'grid' 
                ? _buildGridView() 
                : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[700]!, Colors.blue[500]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderItem(
            Icons.psychology,
            'Prédictions',
            '${_allPredictions.length}',
            Colors.white,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildHeaderItem(
            Icons.grid_on,
            'Champs',
            '${widget.fields.length}',
            Colors.white,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildHeaderItem(
            Icons.water_drop,
            'Moyenne',
            '${_calculateAverageWaterNeed().toStringAsFixed(1)} mm',
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ✅ Vue en grille (moderne)
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _allPredictions.length,
      itemBuilder: (context, index) {
        final prediction = _allPredictions[index];
        final field = _findFieldForPrediction(prediction);
        return _buildGridCard(prediction, field);
      },
    );
  }

  // ✅ Carte pour la grille
  Widget _buildGridCard(PredictionModel prediction, FieldModel? field) {
    final waterColor = _getWaterColor(prediction.predictedWaterNeed);
    
    return GestureDetector(
      onTap: () => _navigateToFieldDetail(prediction),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                waterColor.withOpacity(0.1),
                waterColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec icône
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: waterColor.withOpacity(0.15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.water_drop, color: waterColor, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        field?.name ?? 'Champ inconnu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: waterColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenu
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            prediction.forecastDate.toString().substring(0, 10),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      
                      // Besoin en eau (grand)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              prediction.predictedWaterNeed.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: waterColor,
                              ),
                            ),
                            Text(
                              'mm/jour',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Confiance
                      LinearProgressIndicator(
                        value: prediction.confidence,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(waterColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Confiance: ${prediction.confidence}',
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Vue en liste (compacte)
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allPredictions.length,
      itemBuilder: (context, index) {
        final prediction = _allPredictions[index];
        final field = _findFieldForPrediction(prediction);
        return _buildListCard(prediction, field);
      },
    );
  }

  Widget _buildListCard(PredictionModel prediction, FieldModel? field) {
    final waterColor = _getWaterColor(prediction.predictedWaterNeed);
    
    return GestureDetector(
      onTap: () => _navigateToFieldDetail(prediction),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: waterColor, width: 4),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: waterColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.water_drop, color: waterColor, size: 24),
              ),
              const SizedBox(width: 16),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field?.name ?? 'Champ inconnu',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prediction.forecastDate.toString().substring(0, 10),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Confiance: ${prediction.confidence}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              
              // Valeur
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    prediction.predictedWaterNeed.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: waterColor,
                    ),
                  ),
                  Text(
                    'mm/jour',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getWaterColor(double waterNeed) {
    if (waterNeed < 4) return Colors.green;
    if (waterNeed < 6) return Colors.blue;
    if (waterNeed < 8) return Colors.orange;
    return Colors.red;
  }

  double _calculateAverageWaterNeed() {
    if (_allPredictions.isEmpty) return 0.0;
    final total = _allPredictions.fold(
      0.0,
      (sum, pred) => sum + pred.predictedWaterNeed,
    );
    return total / _allPredictions.length;
  }
}