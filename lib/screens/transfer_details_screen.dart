import 'package:flutter/material.dart';
import '../models/transfer.dart';
import 'package:intl/intl.dart';

class TransferDetailsScreen extends StatelessWidget {
  final Transfer transfer;

  const TransferDetailsScreen({
    Key? key,
    required this.transfer,
  }) : super(key: key);

  Color _getStatusColor(TransferStatus status) {
    switch (status) {
      case TransferStatus.success:
        return Colors.green;
      case TransferStatus.pending:
        return Colors.orange;
      case TransferStatus.failed:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(TransferStatus status) {
    switch (status) {
      case TransferStatus.success:
        return Icons.check_circle;
      case TransferStatus.pending:
        return Icons.pending;
      case TransferStatus.failed:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transfer Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Icon(
                  _getStatusIcon(transfer.status),
                  size: 48,
                  color: _getStatusColor(transfer.status),
                ),
                const SizedBox(height: 24),
                Text(
                  '\$${transfer.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  transfer.status.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(transfer.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.person_outline,
                    label: 'Recipient',
                    value: transfer.recipientName,
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: 'Date & Time',
                    value: DateFormat('MMMM d, y • h:mm a').format(transfer.timestamp),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(
                    context,
                    icon: Icons.receipt_long_outlined,
                    label: 'Transaction ID',
                    value: '#${transfer.id.toString().padLeft(8, '0')}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 