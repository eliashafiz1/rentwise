import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/affordability_result.dart';
import 'results_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<AffordabilityResult> history;
  final VoidCallback onClear;

  const HistoryScreen({
    super.key,
    required this.history,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final percentFormat = NumberFormat('0.0');
    final dateFormat = DateFormat('MMM d, yyyy  h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear All',
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text(
                        'Are you sure you want to delete all saved calculations?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          onClear();
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No calculations yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Run a calculation on the Input tab\nto see results here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Summary bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Text(
                        'Past calculations',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${history.length} result${history.length == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                // ListView of results
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final isAffordable = item.isAffordable;
                      final statusColor = isAffordable
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336);

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // Navigate to full results view
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResultsScreen(result: item),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Status indicator
                                Container(
                                  width: 4,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.city,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  statusColor.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              isAffordable
                                                  ? 'Affordable'
                                                  : 'Not Affordable',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: statusColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Rent: ${currencyFormat.format(item.rent)}  |  '
                                        'Ratio: ${percentFormat.format(item.percentage)}%  |  '
                                        'Income: ${currencyFormat.format(item.income)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dateFormat.format(item.timestamp),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.chevron_right,
                                    color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
