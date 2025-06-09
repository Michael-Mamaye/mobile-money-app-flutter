import 'package:flutter/material.dart';
import '../models/transfer.dart';
import '../services/database_service.dart';
import 'transfer_details_screen.dart';
import 'package:intl/intl.dart';

class RecentTransfersScreen extends StatefulWidget {
  const RecentTransfersScreen({Key? key}) : super(key: key);

  @override
  _RecentTransfersScreenState createState() => _RecentTransfersScreenState();
}

class _RecentTransfersScreenState extends State<RecentTransfersScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Transfer> _transfers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransfers();
  }

  Future<void> _loadTransfers() async {
    setState(() => _isLoading = true);
    try {
      final transfers = await _databaseService.getTransfers();
      setState(() {
        _transfers = transfers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Transfers'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransfers,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _transfers.length,
                itemBuilder: (context, index) {
                  final transfer = _transfers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TransferDetailsScreen(transfer: transfer),
                          ),
                        );
                      },
                      title: Text(
                        transfer.recipientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMM d, y • h:mm a')
                            .format(transfer.timestamp),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${transfer.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(transfer.status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              transfer.status.toString().split('.').last,
                              style: TextStyle(
                                color: _getStatusColor(transfer.status),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
} 