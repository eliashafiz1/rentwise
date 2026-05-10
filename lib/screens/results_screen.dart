import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/affordability_result.dart';

class ResultsScreen extends StatelessWidget {
  final AffordabilityResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final percentFormat = NumberFormat('0.0');

    final statusColor = result.isAffordable
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF44336);
    final statusText = result.isAffordable ? 'Affordable' : 'Not Affordable';
    final statusIcon = result.isAffordable ? Icons.check_circle : Icons.cancel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your affordability analysis',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(statusIcon, size: 48, color: statusColor),
                  const SizedBox(height: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on ${result.threshold}% rule',
                    style: TextStyle(
                      fontSize: 14,
                      color: statusColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Rent-to-Income Ratio Card
            _buildInfoCard(
              icon: Icons.trending_up,
              title: 'Rent-to-Income Ratio',
              value: '${percentFormat.format(result.percentage)}%',
              subtitle: 'Recommended: ≤ ${result.threshold}%',
              valueColor: statusColor,
            ),
            const SizedBox(height: 12),

            // Total Housing Cost Card
            _buildInfoCard(
              icon: Icons.attach_money,
              title: 'Total Housing Cost',
              value: currencyFormat.format(result.totalHousing),
              subtitle: 'Rent + Utilities',
              valueColor: const Color(0xFF2196F3),
            ),
            const SizedBox(height: 12),

            // Remaining Income Card
            _buildInfoCard(
              icon: Icons.account_balance_wallet,
              title: 'Remaining Income',
              value: currencyFormat.format(result.remaining),
              subtitle: 'After housing and debts',
              valueColor: result.remaining >= 0
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFF44336),
            ),
            const SizedBox(height: 24),

            // Breakdown Section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Breakdown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildBreakdownRow('City', result.city),
                    _buildBreakdownRow(
                        'Monthly Income', currencyFormat.format(result.income)),
                    _buildBreakdownRow(
                        'Monthly Rent', currencyFormat.format(result.rent)),
                    _buildBreakdownRow(
                        'Utilities', currencyFormat.format(result.utilities)),
                    _buildBreakdownRow(
                        'Monthly Debts', currencyFormat.format(result.debts)),
                    const Divider(),
                    _buildBreakdownRow('Total Housing Cost',
                        currencyFormat.format(result.totalHousing)),
                    _buildBreakdownRow('Housing-to-Income',
                        '${percentFormat.format(result.percentage)}%'),
                    _buildBreakdownRow(
                        'Threshold', '${result.threshold}%'),
                    _buildBreakdownRow('Remaining Income',
                        currencyFormat.format(result.remaining)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recommendation Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: Color(0xFF2196F3), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.isAffordable
                          ? 'This rental fits within your ${result.threshold}% affordability threshold. '
                            'You would have ${currencyFormat.format(result.remaining)} remaining each month '
                            'after housing costs and debts.'
                          : 'This rental exceeds your ${result.threshold}% affordability threshold. '
                            'Consider looking for a lower rent, reducing other expenses, or '
                            'increasing your income to improve affordability.',
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // New Calculation Button
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('New Calculation'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2196F3),
                  side: const BorderSide(color: Color(0xFF2196F3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color valueColor,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: valueColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: valueColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
