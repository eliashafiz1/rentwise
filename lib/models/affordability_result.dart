import 'dart:convert';

/// Model class representing a single affordability calculation result.
class AffordabilityResult {
  final double income;
  final double rent;
  final double utilities;
  final double debts;
  final double totalHousing;
  final double percentage;
  final double remaining;
  final bool isAffordable;
  final String city;
  final int threshold;
  final DateTime timestamp;

  AffordabilityResult({
    required this.income,
    required this.rent,
    required this.utilities,
    required this.debts,
    required this.totalHousing,
    required this.percentage,
    required this.remaining,
    required this.isAffordable,
    required this.city,
    required this.threshold,
    required this.timestamp,
  });

  /// Convert to a Map for JSON storage.
  Map<String, dynamic> toMap() {
    return {
      'income': income,
      'rent': rent,
      'utilities': utilities,
      'debts': debts,
      'totalHousing': totalHousing,
      'percentage': percentage,
      'remaining': remaining,
      'isAffordable': isAffordable,
      'city': city,
      'threshold': threshold,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create an AffordabilityResult from a Map (for loading from storage).
  factory AffordabilityResult.fromMap(Map<String, dynamic> map) {
    return AffordabilityResult(
      income: (map['income'] as num).toDouble(),
      rent: (map['rent'] as num).toDouble(),
      utilities: (map['utilities'] as num).toDouble(),
      debts: (map['debts'] as num).toDouble(),
      totalHousing: (map['totalHousing'] as num).toDouble(),
      percentage: (map['percentage'] as num).toDouble(),
      remaining: (map['remaining'] as num).toDouble(),
      isAffordable: map['isAffordable'] as bool,
      city: map['city'] as String,
      threshold: map['threshold'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  /// Encode this result to a JSON string.
  String toJson() => jsonEncode(toMap());

  /// Decode a JSON string into an AffordabilityResult.
  factory AffordabilityResult.fromJson(String json) {
    return AffordabilityResult.fromMap(jsonDecode(json) as Map<String, dynamic>);
  }
}
