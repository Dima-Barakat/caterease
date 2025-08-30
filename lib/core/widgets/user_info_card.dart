import 'package:caterease/core/theming/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserInfoCard extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> details;
  final String? latitude;
  final String? longitude;

  const UserInfoCard({
    super.key,
    required this.title,
    required this.details,
    this.latitude,
    this.longitude,
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

                  // Location map button (only shown if coordinates are available)
                  if (latitude != null && longitude != null)
                    const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _showMapDialog(context),
                    child: const Text(
                      "View Location on Map",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            fontWeight: FontWeight.bold,
          ),
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

  void _showMapDialog(BuildContext context) {
    if (latitude != null && longitude != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    double.tryParse(latitude!) ?? 0.0,
                    double.tryParse(longitude!) ?? 0.0,
                  ),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.cater_ease',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          double.tryParse(latitude!) ?? 0.0,
                          double.tryParse(longitude!) ?? 0.0,
                        ),
                        width: 50,
                        height: 50,
                        child: const Icon(Icons.location_on,
                            size: 40, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No location available")),
      );
    }
  }
}
