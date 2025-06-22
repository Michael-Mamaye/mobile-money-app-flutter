import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/transfer.dart';

class ConfirmationScreen extends StatefulWidget {
  final String bankName;
  final String accountNumber;
  final double amount;
  final String description;

  const ConfirmationScreen({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.amount,
    required this.description,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final _pinController = TextEditingController();
  final _databaseService = DatabaseService();
  bool _showSuccess = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submitPin() async {
    if (_pinController.text.length == 4) {
      setState(() => _isLoading = true);
      
      try {
        // Create a new transfer
        final transfer = Transfer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          recipientName: '${widget.bankName} - ${widget.accountNumber}',
          amount: widget.amount,
          timestamp: DateTime.now(),
          status: TransferStatus.success,
        );

        // Save the transfer to database
        await _databaseService.addTransfer(transfer);

        setState(() {
          _showSuccess = true;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to process transaction. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                'Transaction Successful!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Bank', widget.bankName),
                    _buildDetailRow('Account', widget.accountNumber),
                    _buildDetailRow('Amount', '${widget.amount} Birr'),
                    if (widget.description.isNotEmpty)
                      _buildDetailRow('Description', widget.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Enter PIN',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pinController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter 4-digit PIN',
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitPin,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
} 