import 'location_model.dart';

class OrderTrackingModel {
  final String status;
  final LocationModel location;
  final DateTime timestamp;
  final String note;

  OrderTrackingModel({
    required this.status,
    required this.location,
    required this.timestamp,
    required this.note,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      status: json['status'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'location': location.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }
}