import 'package:flutter/foundation.dart';

enum TransferStatus {
  success,
  pending,
  failed
}

class Transfer {
  final String id;
  final String recipientName;
  final double amount;
  final DateTime timestamp;
  final TransferStatus status;

  Transfer({
    required this.id,
    required this.recipientName,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientName': recipientName,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'] as String,
      recipientName: json['recipientName'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: TransferStatus.values.firstWhere(
        (e) => e.toString() == 'TransferStatus.${json['status']}',
      ),
    );
  }
} 