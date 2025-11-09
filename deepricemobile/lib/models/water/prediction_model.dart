class PredictionModel {
  final int id;
  final int fieldId;
  final DateTime predictionDate;
  final DateTime forecastDate; // ⬅️ NOUVEAU champ
  final double predictedWaterNeed; // mm/day
  final double? temperatureCelsius; // ⬅️ NOUVEAU
  final double? humidityPercent; // ⬅️ NOUVEAU
  final double? rainfallMm; // ⬅️ NOUVEAU
  final double? netIrrigationMm; // ⬅️ NOUVEAU
  final double? evapotranspirationMm; // ⬅️ NOUVEAU
  final double? confidence;
  final String? modelVersion;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  PredictionModel({
    required this.id,
    required this.fieldId,
    required this.predictionDate,
    required this.forecastDate, // ⬅️
    required this.predictedWaterNeed,
    this.temperatureCelsius,
    this.humidityPercent,
    this.rainfallMm,
    this.netIrrigationMm,
    this.evapotranspirationMm,
    this.confidence,
    this.modelVersion,
    this.metadata,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create PredictionModel from JSON - CORRIGÉ
  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'] as int,
      fieldId: json['parcel_id'] as int,
      predictionDate: DateTime.parse(json['prediction_date'] as String),
      forecastDate: DateTime.parse(json['forecast_date'] as String), // ⬅️
      predictedWaterNeed: (json['water_needed_mm'] as num).toDouble(),
      temperatureCelsius: json['temperature_celsius'] != null 
          ? (json['temperature_celsius'] as num).toDouble() 
          : null,
      humidityPercent: json['humidity_percent'] != null 
          ? (json['humidity_percent'] as num).toDouble() 
          : null,
      rainfallMm: json['rainfall_mm'] != null 
          ? (json['rainfall_mm'] as num).toDouble() 
          : null,
      netIrrigationMm: json['net_irrigation_mm'] != null 
          ? (json['net_irrigation_mm'] as num).toDouble() 
          : null,
      evapotranspirationMm: json['evapotranspiration_mm'] != null 
          ? (json['evapotranspiration_mm'] as num).toDouble() 
          : null,
      confidence: json['confidence_score'] != null
          ? (json['confidence_score'] as num).toDouble()
          : null,
      modelVersion: json['model_version'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convert PredictionModel to JSON - CORRIGÉ
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'parcel_id': fieldId,
      'prediction_date': predictionDate.toIso8601String(),
      'forecast_date': forecastDate.toIso8601String().split('T')[0], // ⬅️
      'water_needed_mm': predictedWaterNeed,
      if (temperatureCelsius != null) 'temperature_celsius': temperatureCelsius,
      if (humidityPercent != null) 'humidity_percent': humidityPercent,
      if (rainfallMm != null) 'rainfall_mm': rainfallMm,
      if (netIrrigationMm != null) 'net_irrigation_mm': netIrrigationMm,
      if (evapotranspirationMm != null) 'evapotranspiration_mm': evapotranspirationMm,
      if (confidence != null) 'confidence_score': confidence,
      if (modelVersion != null) 'model_version': modelVersion,
      if (metadata != null) 'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Mettez à jour copyWith pour inclure les nouveaux champs
  PredictionModel copyWith({
    int? id,
    int? fieldId,
    DateTime? predictionDate,
    DateTime? forecastDate, // ⬅️
    double? predictedWaterNeed,
    double? temperatureCelsius, // ⬅️
    double? humidityPercent, // ⬅️
    double? rainfallMm, // ⬅️
    double? netIrrigationMm, // ⬅️
    double? evapotranspirationMm, // ⬅️
    double? confidence,
    String? modelVersion,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return PredictionModel(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      predictionDate: predictionDate ?? this.predictionDate,
      forecastDate: forecastDate ?? this.forecastDate, // ⬅️
      predictedWaterNeed: predictedWaterNeed ?? this.predictedWaterNeed,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius, // ⬅️
      humidityPercent: humidityPercent ?? this.humidityPercent, // ⬅️
      rainfallMm: rainfallMm ?? this.rainfallMm, // ⬅️
      netIrrigationMm: netIrrigationMm ?? this.netIrrigationMm, // ⬅️
      evapotranspirationMm: evapotranspirationMm ?? this.evapotranspirationMm, // ⬅️
      confidence: confidence ?? this.confidence,
      modelVersion: modelVersion ?? this.modelVersion,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Ajoutez des getters utiles pour les nouveaux champs
  String get formattedForecastDate {
    return '${forecastDate.day}/${forecastDate.month}/${forecastDate.year}';
  }

  /// Check if prediction is for today (basé sur forecastDate maintenant)
  bool get isToday {
    final now = DateTime.now();
    return forecastDate.year == now.year &&
        forecastDate.month == now.month &&
        forecastDate.day == now.day;
  }

  /// Check if prediction is in the past (basé sur forecastDate)
  bool get isPast {
    return forecastDate.isBefore(DateTime.now());
  }

  /// Check if prediction is in the future (basé sur forecastDate)
  bool get isFuture {
    return forecastDate.isAfter(DateTime.now());
  }

  // ... reste des méthodes existantes
}