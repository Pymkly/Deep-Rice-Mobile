class SensorDataModel {
  final int? id;
  final String sensorId;
  final int potoId;
  final int parcelId;
  final DateTime timestamp;
  final double? moisturePercent;        // humidity of soil
  final double? soilTemperatureCelsius; // temperature of soil
  final double? depthCm;                // depth in cm
  final double? batteryLevelPercent;    // battery level
  final String? potoRef;
  final DateTime createdAt;

  SensorDataModel({
    this.id,
    required this.sensorId,
    required this.potoId,
    required this.parcelId,
    required this.timestamp,
    this.moisturePercent,
    this.soilTemperatureCelsius,
    this.depthCm,
    this.batteryLevelPercent,
    this.potoRef,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create SensorDataModel from JSON
  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      id: json['id'] as int?,
      sensorId: json['sensor_id'] as String,
      potoId: json['poto_id'] as int,
      parcelId: json['parcel_id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      moisturePercent: json['moisture_percent'] != null
          ? (json['moisture_percent'] as num).toDouble()
          : null,
      soilTemperatureCelsius: json['soil_temperature_celsius'] != null
          ? (json['soil_temperature_celsius'] as num).toDouble()
          : null,
      depthCm: json['depth_cm'] != null
          ? (json['depth_cm'] as num).toDouble()
          : null,
      batteryLevelPercent: json['battery_level_percent'] != null
          ? (json['battery_level_percent'] as num).toDouble()
          : null,
      potoRef: json['poto_ref'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convert SensorDataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sensor_id': sensorId,
      'poto_id': potoId,
      'parcel_id': parcelId,
      'timestamp': timestamp.toIso8601String(),
      if (moisturePercent != null) 'moisture_percent': moisturePercent,
      if (soilTemperatureCelsius != null)
        'soil_temperature_celsius': soilTemperatureCelsius,
      if (depthCm != null) 'depth_cm': depthCm,
      if (batteryLevelPercent != null)
        'battery_level_percent': batteryLevelPercent,
      if (potoRef != null) 'poto_ref': potoRef,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copy with modified fields
  SensorDataModel copyWith({
    int? id,
    String? sensorId,
    int? potoId,
    int? parcelId,
    DateTime? timestamp,
    double? moisturePercent,
    double? soilTemperatureCelsius,
    double? depthCm,
    double? batteryLevelPercent,
    String? potoRef,
    DateTime? createdAt,
  }) {
    return SensorDataModel(
      id: id ?? this.id,
      sensorId: sensorId ?? this.sensorId,
      potoId: potoId ?? this.potoId,
      parcelId: parcelId ?? this.parcelId,
      timestamp: timestamp ?? this.timestamp,
      moisturePercent: moisturePercent ?? this.moisturePercent,
      soilTemperatureCelsius:
          soilTemperatureCelsius ?? this.soilTemperatureCelsius,
      depthCm: depthCm ?? this.depthCm,
      batteryLevelPercent: batteryLevelPercent ?? this.batteryLevelPercent,
      potoRef: potoRef ?? this.potoRef,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Format date
  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'SensorDataModel(id: $id, sensor: $sensorId, parcel: $parcelId, '
        'moisture: $moisturePercent%, temp: $soilTemperatureCelsius°C, depth: $depthCm cm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SensorDataModel &&
        other.id == id &&
        other.sensorId == sensorId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      id.hashCode ^ sensorId.hashCode ^ timestamp.hashCode;
}
