import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker {
  static Future<LatLng?> pickLocation(BuildContext context,
      {LatLng? initialLocation}) async {
    LatLng selectedLocation =
        initialLocation ?? LatLng(33.5138, 36.2765); // Default: Damascus

    return await showDialog<LatLng>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: selectedLocation,
                    initialZoom: 13,
                    onTap: (tapPosition, point) {
                      setState(() {
                        selectedLocation = point;
                      });
                    },
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
                          point: selectedLocation,
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
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selectedLocation),
                  child: const Text("Select"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
