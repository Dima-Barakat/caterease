import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong;

class LocationPicker extends StatefulWidget {
  final latlong.LatLng? initialLocation;
  final Function(latlong.LatLng, String?, String?) onLocationSelected;

  const LocationPicker({
    Key? key,
    this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  latlong.LatLng? _selectedLocation;
  String? _cityName;
  String? _streetName;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  Future<void> _reverseGeocode(latlong.LatLng pos) async {
    try {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?lat=${pos.latitude}&lon=${pos.longitude}&format=json&addressdetails=1&zoom=18&accept-language=ar");
      final res = await http.get(url, headers: {
        'User-Agent': 'caterease/1.0 (contact@caterease.com)',
      });

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        // Extract the whole address object
        final addressDetails = data['address'] ?? {};

        // Try to get street-related fields
        final street = addressDetails['road'] ?? '';
        final state = addressDetails['state'] ?? '';
        List<String> parts = state.split(" ");
        String city = parts.length > 1 ? parts[1] : "";

        setState(() {
          _streetName = street.isNotEmpty ? street : null;
          _cityName = city.isNotEmpty ? city : null;
        });

        widget.onLocationSelected(
            pos,
            street.isNotEmpty ? street : data['city'],
            city.isNotEmpty ? city : null);
      }
    } catch (_) {
      setState(() {
        _streetName = null;
        _cityName = null;
      });
      widget.onLocationSelected(pos, null, null);
    }
  }

  void _onMapTap(latlong.LatLng latLng) async {
    setState(() {
      _selectedLocation = latLng;
    });
    await _reverseGeocode(latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation ??
                        const latlong.LatLng(33.5138, 36.2765),
                    initialZoom: 15,
                    onTap: (tapPos, latLng) => _onMapTap(latLng),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation!,
                            width: 60,
                            height: 60,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
