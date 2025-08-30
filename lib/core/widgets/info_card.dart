import 'package:caterease/core/theming/app_theme.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> details;

  const InfoCard({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Details list
                  ...details.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _buildInfoRow(item.key, item.value),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label: ",
        style: const TextStyle(
            color: Color(0xFF314E76),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            color: Color(0xFF314E76),
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}
