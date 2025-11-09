import 'package:flutter/material.dart';
import '../../../services/water_api_service.dart';
import '../../../models/water/field_model.dart';
import '../../../models/water/sensor_data_model.dart';

/// Test screen for Water API Service
class TestWaterApiScreen extends StatefulWidget {
  const TestWaterApiScreen({super.key});

  @override
  State<TestWaterApiScreen> createState() => _TestWaterApiScreenState();
}

class _TestWaterApiScreenState extends State<TestWaterApiScreen> {
  final WaterApiService _api = WaterApiService();
  final List<String> _logs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addLog('🚀 Test API initialized');
    _addLog('📍 Base URL: ${_api.getBaseUrl()}');
  }

  void _addLog(String message) {
    setState(() {
      _logs.insert(
          0, '[${DateTime.now().toString().substring(11, 19)}] $message');
    });
  }

  Future<void> _testConnection() async {
    setState(() => _isLoading = true);
    _addLog('🔄 Testing API connection...');

    try {
      final isConnected = await _api.testConnection();
      _addLog(isConnected ? '✅ API Connected!' : '❌ API Connection Failed');
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testGetAllFields() async {
    setState(() => _isLoading = true);
    _addLog('🔄 Fetching all fields...');

    try {
      final fields = await _api.getAllFields();
      _addLog('✅ Found ${fields.length} fields');
      for (var field in fields.take(3)) {
        _addLog('   - ${field.name} (${field.area}ha)');
      }
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testCreateField() async {
    setState(() => _isLoading = true);
    _addLog('🔄 Creating test field...');

    try {
      final newField = FieldModel(
        name: 'Test Field ${DateTime.now().millisecond}',
        area: 2.5,
        location: 'Antananarivo',
        cropType: 'Rice',
        plantingDate: DateTime.now(),
      );

      final createdField = await _api.createField(newField);
      _addLog('✅ Field created with ID: ${createdField.id}');
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testSendSensorData() async {
    setState(() => _isLoading = true);
    _addLog('🔄 Sending sensor data...');

    try {
      final sensorData = SensorDataModel(
        parcelId: 1, // Assuming field ID 1 exists
        sensorId: 'SENSOR_001', // Assuming field ID 1 exists
        potoId: 1, // Assuming field ID 1 exists
        timestamp: DateTime.now(),
        moisturePercent: 65.5,
        soilTemperatureCelsius: 28.3,
        depthCm: 75.0,
        batteryLevelPercent: 2.5,
        potoRef: 'POTO#0001',
        createdAt: DateTime.now(),
      );

      final sent = await _api.sendSensorData(sensorData);
      _addLog('✅ Sensor data sent with ID: ${sent.id}');
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

//   Future<void> _testGetPredictions() async {
//   setState(() => _isLoading = true);
//   _addLog('🔄 Fetching predictions...');

//   try {
//     final predictions = await _api.getPredictionsByField(1);
//     _addLog('✅ Found ${predictions.length} predictions');

//     for (var pred in predictions.take(3)) {
//       final date = pred.predictionDate != null
//           ? pred.predictionDate.toString().substring(0, 10)
//           : 'N/A';
//       _addLog(
//           '   - $date → ${pred.predictedWaterNeed.toStringAsFixed(2)} mm/jour (Conf: ${pred.confidencePercentage})');
//     }
//   } catch (e) {
//     _addLog('❌ Error fetching predictions: $e');
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }

  // Future<void> _testGeneratePrediction() async {
  //   setState(() => _isLoading = true);
  //   _addLog('🔄 Generating new prediction...');

  //   try {
  //     final prediction = await _api.generatePrediction(
  //       fieldId: 1,
  //       predictionDate: DateTime.now().add(const Duration(days: 1)),
  //     );
  //     _addLog(
  //         '✅ Prediction generated: ${prediction.predictedWaterNeed}mm/jour');
  //     _addLog('   Confidence: ${prediction.confidencePercentage}');
  //   } catch (e) {
  //     _addLog('❌ Error: $e');
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _testGetRecommendations() async {
    setState(() => _isLoading = true);
    _addLog('🔄 Fetching recommendations...');

    try {
      final recommendations = await _api.getRecommendations(1);
      _addLog('✅ Recommendations received');
      _addLog('   Data: ${recommendations.toString()}');
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearLogs() {
    setState(() => _logs.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water API Test (HTTP)'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearLogs,
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Test Buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testConnection,
                        child: const Text('Test Connection'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testGetAllFields,
                        child: const Text('Get Fields'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testCreateField,
                        child: const Text('Create Field'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testSendSensorData,
                        child: const Text('Send Sensor'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Row(
                //   children: [
                //     Expanded(
                //       child: ElevatedButton(
                //         onPressed: _isLoading ? null : _testGetPredictions,
                //         child: const Text('Get Predictions'),
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     // Expanded(
                //     //   child: ElevatedButton(
                //     //     onPressed: _isLoading ? null : _testGeneratePrediction,
                //     //     child: const Text('Generate Pred'),
                //     //   ),
                //     // ),
                //   ],
                // ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testGetRecommendations,
                    child: const Text('Get Recommendations'),
                  ),
                ),
              ],
            ),
          ),

          // Loading indicator
          if (_isLoading) const LinearProgressIndicator(),

          // Logs
          Expanded(
            child: Container(
              color: Colors.black,
              child: _logs.isEmpty
                  ? const Center(
                      child: Text(
                        'No logs yet. Start testing!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            _logs[index],
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: _logs[index].contains('✅')
                                  ? Colors.green
                                  : _logs[index].contains('❌')
                                      ? Colors.red
                                      : _logs[index].contains('🔄')
                                          ? Colors.yellow
                                          : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
