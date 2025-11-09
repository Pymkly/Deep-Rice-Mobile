class FieldModel {
  final int? id;
  final int? fieldId;
  final String? name;
  final double? area;
  final String? location;
  final String? cropType;
  final DateTime? plantingDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FieldModel({
    this.id,
    this.fieldId,
    required this.name,
    required this.area,
    required this.location,
    this.cropType,
    this.plantingDate,
    this.createdAt,
    this.updatedAt,
  }); 

  /// Create FieldModel from JSON
  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: _parseInt(json['field_id']),
      fieldId: _parseInt(json['field_id']),
      name: json['name'] as String? ?? 'Unknown',
      area: _parseDouble(json['area']),
      location: json['location'] as String? ?? 'Unknown',
      cropType: json['crop_type'] as String?,
      plantingDate: _parseDateTime(json['planting_date']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  // ✅ Helper pour parser int de manière sûre
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  // ✅ Helper pour parser double de manière sûre
  static double? _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // ✅ Helper pour parser DateTime de manière sûre
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Convert FieldModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'field_id': id,
      'name': name,
      'area': area,
      'location': location,
      if (cropType != null) 'crop_type': cropType,
      if (plantingDate != null)
        'planting_date': plantingDate!.toIso8601String().split('T')[0],
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  FieldModel copyWith({
    int? id,
    String? name,
    double? area,
    String? location,
    String? cropType,
    DateTime? plantingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FieldModel(
      id: id ?? this.id,
      name: name ?? this.name,
      area: area ?? this.area,
      location: location ?? this.location,
      cropType: cropType ?? this.cropType,
      plantingDate: plantingDate ?? this.plantingDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FieldModel(id: $id, name: $name, area: ${area}ha, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FieldModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
