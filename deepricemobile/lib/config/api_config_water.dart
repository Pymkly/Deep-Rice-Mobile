import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized API Configuration
class ApiConfig {
  // Private constructor for singleton
  ApiConfig._();

  static final ApiConfig _instance = ApiConfig._();
  static ApiConfig get instance => _instance;

  /// Base URL from .env file
  String get baseUrl {
    final ip = dotenv.env['IP'] ?? 'localhost:8000';
    return 'https://$ip';
  }

  /// API Base Path
  String get apiBasePath {
    final baseUrl = dotenv.env['APIBASEURL'];
    return baseUrl != null ? '$baseUrl/water' : '/api/water';
  }

  /// Full API URL
  String get apiUrl => '$baseUrl$apiBasePath';

  /// Water Module Endpoints
  static const String waterFields = '/fields';
  static const String waterSensorData = '/sensor-data';
  static const String waterPredictions = '/predictions';
  static const String waterPredict = '/predict';
  static const String waterRecommendations = '/recommendations';

  
  /// Timeout configurations
  // static const Duration connectTimeout = Duration(seconds: 30);
  // static const Duration receiveTimeout = Duration(seconds: 30);
  // static const Duration sendTimeout = Duration(seconds: 30);

  /// Debug mode
  static const bool debugMode = true;

  @override
  String toString() {
    return 'ApiConfig(baseUrl: $baseUrl, apiUrl: $apiUrl)';
  }
}
