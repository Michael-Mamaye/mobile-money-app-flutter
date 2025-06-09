import 'package:flutter/material.dart';
import 'package:mobilemoney/screens/add_money/receive_from_abroad_screen.dart';

class AddMoneyScreen extends StatelessWidget {
  const AddMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final transferOptions = [
      {
        'title': 'Receive from Abroad',
        'subtitle': 'Receive money from international sources',
        'icon': Icons.flight_land,
        'color': theme.colorScheme.primary,
      },
      {
        'title': 'Deposit at Agent',
        'subtitle': 'Visit an agent to deposit cash',
        'icon': Icons.store,
        'color': theme.colorScheme.secondary,
      },
      {
        'title': 'Ask a Friend',
        'subtitle': 'Request money from your contacts',
        'icon': Icons.people,
        'color': theme.colorScheme.tertiary,
      },
      {
        'title': 'Transfer from Bank',
        'subtitle': 'Transfer money from your bank account',
        'icon': Icons.account_balance,
        'color': theme.colorScheme.primary,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Money',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.background,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: transferOptions.length,
          itemBuilder: (context, index) {
            final option = transferOptions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  if (option['title'] == 'Receive from Abroad') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReceiveFromAbroadScreen(),
                      ),
                    );
                  }
                  // TODO: Implement other options
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (option['color'] as Color).withOpacity(0.1),
                        (option['color'] as Color).withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (option['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          option['icon'] as IconData,
                          color: option['color'] as Color,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['title'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              option['subtitle'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 