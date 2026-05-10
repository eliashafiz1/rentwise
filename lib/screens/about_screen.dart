import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // App Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.home_work,
                size: 56,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 20),

            // App Name
            const Text(
              'RentWise',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // Divider
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 20),

            // Description
            _buildSection(
              icon: Icons.info_outline,
              title: 'Description',
              content:
                  'RentWise is a comprehensive rent affordability calculator '
                  'designed to help you make informed decisions about your housing '
                  'budget. The app calculates your rent-to-income ratio and helps '
                  'you determine if a rental property fits within your financial means.',
            ),
            const SizedBox(height: 24),

            // Features
            _buildSection(
              icon: Icons.star_outline,
              title: 'Features',
              content:
                  '• Calculate rent affordability based on income and expenses\n'
                  '• Compare multiple rental scenarios side by side\n'
                  '• Built-in average rent data for major U.S. cities\n'
                  '• Adjustable affordability thresholds (30%, 35%, 40%)\n'
                  '• Save and review past calculations',
            ),
            const SizedBox(height: 24),

            // Developer Info
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 20),

            _buildInfoRow(Icons.person, 'Developer', 'Elias Hafiz'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.school, 'Course', 'IT 315 - Mobile App Development'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.account_balance, 'University', 'George Mason University'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, 'Semester', 'Spring 2026'),
            const SizedBox(height: 24),

            // Copyright
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              '© 2026 Elias Hafiz',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'All rights reserved.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Built with Flutter & Dart',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF2196F3)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
