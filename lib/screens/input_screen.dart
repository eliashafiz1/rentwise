import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/city_data.dart';
import '../models/affordability_result.dart';
import 'results_screen.dart';

class InputScreen extends StatefulWidget {
  final Function(AffordabilityResult) onCalculate;

  const InputScreen({super.key, required this.onCalculate});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _incomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _utilitiesController = TextEditingController();
  final _debtsController = TextEditingController();

  // Dropdown selections
  String _selectedCity = cityRentData.keys.first;
  int _selectedThreshold = affordabilityThresholds.first;

  @override
  void initState() {
    super.initState();
    // Pre-fill rent with the selected city's average
    _rentController.text = cityRentData[_selectedCity]!.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _rentController.dispose();
    _utilitiesController.dispose();
    _debtsController.dispose();
    super.dispose();
  }

  /// Validates that a string is a positive number.
  String? _validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    final number = double.tryParse(value.trim());
    if (number == null || number < 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  /// Core affordability calculation.
  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final income = double.parse(_incomeController.text.trim());
    final rent = double.parse(_rentController.text.trim());
    final utilities = double.parse(_utilitiesController.text.trim());
    final debts = double.parse(_debtsController.text.trim());

    final totalHousing = rent + utilities;
    final percentage = (totalHousing / income) * 100;
    final remaining = income - totalHousing - debts;
    final isAffordable = percentage <= _selectedThreshold;

    final result = AffordabilityResult(
      income: income,
      rent: rent,
      utilities: utilities,
      debts: debts,
      totalHousing: totalHousing,
      percentage: percentage,
      remaining: remaining,
      isAffordable: isAffordable,
      city: _selectedCity,
      threshold: _selectedThreshold,
      timestamp: DateTime.now(),
    );

    // Add to history
    widget.onCalculate(result);

    // Navigate to results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RentWise'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Calculate your rent affordability',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Monthly Income
              TextFormField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Income (\$)',
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'e.g. 4500',
                ),
                validator: (v) => _validatePositiveNumber(v, 'monthly income'),
              ),
              const SizedBox(height: 16),

              // Monthly Rent
              TextFormField(
                controller: _rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Rent (\$)',
                  prefixIcon: Icon(Icons.home),
                  hintText: 'e.g. 1400',
                ),
                validator: (v) => _validatePositiveNumber(v, 'monthly rent'),
              ),
              const SizedBox(height: 16),

              // Estimated Utilities
              TextFormField(
                controller: _utilitiesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Utilities (\$)',
                  prefixIcon: Icon(Icons.bolt),
                  hintText: 'e.g. 150',
                ),
                validator: (v) => _validatePositiveNumber(v, 'utilities'),
              ),
              const SizedBox(height: 16),

              // Monthly Debts
              TextFormField(
                controller: _debtsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Debts (\$)',
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: 'e.g. 300',
                ),
                validator: (v) => _validatePositiveNumber(v, 'debts'),
              ),
              const SizedBox(height: 20),

              // City Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city),
                ),
                items: cityRentData.keys.map((city) {
                  final avgRent = NumberFormat.currency(symbol: '\$', decimalDigits: 0)
                      .format(cityRentData[city]);
                  return DropdownMenuItem(
                    value: city,
                    child: Text('$city (avg $avgRent)'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCity = value;
                      // Update rent field with city average
                      _rentController.text =
                          cityRentData[value]!.toStringAsFixed(0);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Affordability Rule Dropdown
              DropdownButtonFormField<int>(
                value: _selectedThreshold,
                decoration: const InputDecoration(
                  labelText: 'Affordability Rule',
                  prefixIcon: Icon(Icons.percent),
                ),
                items: affordabilityThresholds.map((threshold) {
                  return DropdownMenuItem(
                    value: threshold,
                    child: Text('$threshold% of Income'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedThreshold = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 28),

              // Calculate Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Calculate Affordability'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
