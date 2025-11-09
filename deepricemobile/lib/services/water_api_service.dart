import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config_water.dart';
import '../models/water/field_model.dart';
import '../models/water/sensor_data_model.dart';
import '../models/water/prediction_model.dart';

/// Service for Water Management API
class WaterApiService {
  // Singleton pattern
  static final WaterApiService _instance = WaterApiService._internal();
  factory WaterApiService() => _instance;
  WaterApiService._internal();

  final ApiConfig _config = ApiConfig.instance;

  /// Initialize service
  void initialize() {
    print('✅ WaterApiService initialized');
    print('📍 Base URL: ${_config.apiUrl}');
  }

  /// Get common headers
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'User-Agent': 'DeepRiceMobile/1.0',
      };

  /// Handle HTTP errors
  void _handleError(http.Response response) {
    if (ApiConfig.debugMode) {
      print('⚠️ HTTP Error ${response.statusCode}: ${response.body}');
    }
  }

  /// Check response and throw error if needed
  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _handleError(response);
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // ==================== FIELDS ENDPOINTS ====================

  /// GET /water/fields/ - Get all fields
  Future<List<FieldModel>> getAllFields() async {
    try {
      final url = Uri.parse('${_config.apiUrl}${ApiConfig.waterFields}');

      if (ApiConfig.debugMode) {
        print('🔄 GET $url');
      }

      final response = await http.get(url, headers: _headers);
      _checkResponse(response);

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => FieldModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching fields: $e');
      rethrow;
    }
  }

  /// POST /water/fields/ - Create a new field
  Future<FieldModel> createField(FieldModel field) async {
    try {
      final url = Uri.parse('${_config.apiUrl}${ApiConfig.waterFields}');

      if (ApiConfig.debugMode) {
        print('🔄 POST $url');
        print('📤 Body: ${json.encode(field.toJson())}');
      }

      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(field.toJson()),
      );
      _checkResponse(response);

      return FieldModel.fromJson(json.decode(response.body));
    } catch (e) {
      print('❌ Error creating field: $e');
      rethrow;
    }
  }

  /// GET /water/fields/{id} - Get field by ID
  Future<FieldModel> getFieldById(int fieldId) async {
    try {
      final url =
          Uri.parse('${_config.apiUrl}${ApiConfig.waterFields}/$fieldId');

      if (ApiConfig.debugMode) {
        print('🔄 GET $url');
      }

      final response = await http.get(url, headers: _headers);
      _checkResponse(response);

      return FieldModel.fromJson(json.decode(response.body));
    } catch (e) {
      print('❌ Error fetching field $fieldId: $e');
      rethrow;
    }
  }

  /// PUT /water/fields/{id} - Update field
  Future<FieldModel> updateField(int fieldId, FieldModel field) async {
    try {
      final url =
          Uri.parse('${_config.apiUrl}${ApiConfig.waterFields}/$fieldId');

      if (ApiConfig.debugMode) {
        print('🔄 PUT $url');
        print('📤 Body: ${json.encode(field.toJson())}');
      }

      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode(field.toJson()),
      );
      _checkResponse(response);

      return FieldModel.fromJson(json.decode(response.body));
    } catch (e) {
      print('❌ Error updating field $fieldId: $e');
      rethrow;
    }
  }

  /// DELETE /water/fields/{id} - Delete field
  Future<void> deleteField(int fieldId) async {
    try {
      final url =
          Uri.parse('${_config.apiUrl}${ApiConfig.waterFields}/$fieldId');

      if (ApiConfig.debugMode) {
        print('🔄 DELETE $url');
      }

      final response = await http.delete(url, headers: _headers);
      _checkResponse(response);

      print('✅ Field $fieldId deleted successfully');
    } catch (e) {
      print('❌ Error deleting field $fieldId: $e');
      rethrow;
    }
  }

  // ==================== SENSOR DATA ENDPOINTS ====================

  /// POST /water/sensor-data/ - Send sensor data
  Future<SensorDataModel> sendSensorData(SensorDataModel sensorData) async {
    try {
      final url = Uri.parse('${_config.apiUrl}${ApiConfig.waterSensorData}');

      if (ApiConfig.debugMode) {
        print('🔄 POST $url');
        print('📤 Body: ${json.encode(sensorData.toJson())}');
      }

      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(sensorData.toJson()),
      );
      _checkResponse(response);

      return SensorDataModel.fromJson(json.decode(response.body));
    } catch (e) {
      print('❌ Error sending sensor data: $e');
      rethrow;
    }
  }

  /// GET /water/sensor-data/{parcel_id} - Get sensor data for a field
  Future<List<SensorDataModel>> getSensorDataByField(int fieldId) async {
    try {
      final url =
          Uri.parse('${_config.apiUrl}${ApiConfig.waterSensorData}/$fieldId');

      if (ApiConfig.debugMode) {
        print('🔄 GET $url');
      }

      final response = await http.get(url, headers: _headers);
      _checkResponse(response);

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SensorDataModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching sensor data for field $fieldId: $e');
      rethrow;
    }
  }

  // ==================== PREDICTIONS ENDPOINTS ====================

  /// GET /water/predictions/{parcel_id} - Get predictions for a field
  Future<List<PredictionModel>> getPredictionsByField(int fieldId) async {
    try {
      final url =
          Uri.parse('${_config.apiUrl}${ApiConfig.waterPredictions}/$fieldId');

      if (ApiConfig.debugMode) {
        print('🔄 GET $url');
      }

      final response = await http.get(url, headers: _headers);
      _checkResponse(response);

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PredictionModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching predictions for field $fieldId: $e');
      rethrow;
    }
  }

  /// POST /water/predict/ - Generate new prediction
  Future<PredictionModel> generatePrediction({
    required int fieldId,
    required DateTime predictionDate,
  }) async {
    try {
      final url = Uri.parse('${_config.apiUrl}${ApiConfig.waterPredict}');

      final body = {
        'parcel_id': fieldId,
        'prediction_date': predictionDate.toIso8601String().split('T')[0],
      };

      if (ApiConfig.debugMode) {
        print('🔄 POST $url');
        print('📤 Body: ${json.encode(body)}');
      }

      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      _checkResponse(response);

      return PredictionModel.fromJson(json.decode(response.body));
    } catch (e) {
      print('❌ Error generating prediction: $e');
      rethrow;
    }
  }

  // ==================== RECOMMENDATIONS ENDPOINTS ====================

  /// GET /water/recommendations/{parcel_id} - Get water recommendations
Future<Map<String, dynamic>> getRecommendations(int fieldId) async {
  try {
    final url = Uri.parse(
        '${_config.apiUrl}${ApiConfig.waterRecommendations}/$fieldId');

    if (ApiConfig.debugMode) {
      print('🔄 GET $url');
    }

    final response = await http.get(url, headers: _headers);
    _checkResponse(response);

    final dynamic data = json.decode(response.body);
    
    // ⬇️ GESTION DES DEUX CAS : Array ou Object
    if (data is List) {
      // Si c'est une liste, prendre le premier élément ou créer un map vide
      if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
        return data[0] as Map<String, dynamic>;
      } else {
        return {'message': 'Aucune recommandation disponible'};
      }
    } else if (data is Map<String, dynamic>) {
      return data;
    } else {
      return {'message': 'Format de recommandation non supporté'};
    }
  } catch (e) {
    print('❌ Error fetching recommendations for field $fieldId: $e');
    rethrow;
  }
}

  // ==================== UTILITY METHODS ====================

  /// Test API connection
  /// final url = Uri.parse('${_config.apiUrl}${ApiConfig.waterFields}');
  Future<bool> testConnection() async {
    try {
      final url = Uri.parse('${_config.apiUrl}/ping');
      //    final url = Uri.parse('https://d2df2be2b04c.ngrok-free.app/ping');

      if (ApiConfig.debugMode) {
        print('🔄 Testing connection to $url');
      }

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        print('✅ API Connection Succeeded');
        print('📥 Response: ${response.body}');
        return true;
      } else {
        print('❌ Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ API Connection Failed: $e');
      return false;
    }
  }

  /// Get base URL (for debugging)
  String getBaseUrl() => _config.apiUrl;
}
