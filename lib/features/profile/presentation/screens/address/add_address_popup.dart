import 'package:caterease/features/profile/presentation/controller/bloc/address/address_bloc.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_event.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_state.dart';
import 'package:caterease/features/profile/presentation/screens/profile/profile_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressPopup extends StatefulWidget {
  const AddAddressPopup({super.key});

  @override
  State<AddAddressPopup> createState() => _AddAddressPopupState();
}

class _AddAddressPopupState extends State<AddAddressPopup> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  String? selectedCityId;
  final List<Map<String, String>> cities = [
    {'id': '1', 'name': 'Damascus'},
    {'id': '2', 'name': 'Aleppo'},
    {'id': '3', 'name': 'Homs'},
    {'id': '4', 'name': 'Latakia'},
    {'id': '5', 'name': 'Damascus-countryside'},
  ];

  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();

  final String staticLatitude = "33.5138";
  final String staticLongitude = "36.2765";

  @override
  void dispose() {
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressLoading) {
          setState(() => isSubmitting = true);
        } else {
          setState(() => isSubmitting = false);
        }

        if (state is AddressCreated) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ProfileViewPage()));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Address saved successfully")),
          );
        }

        if (state is AddressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // City Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCityId,
                  decoration: _inputDecoration("Select city"),
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city['id'],
                      child: Text(city['name']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedCityId = value),
                  validator: (value) =>
                      value == null ? 'Please select a city' : null,
                ),

                const SizedBox(height: 12),

                // Street
                TextFormField(
                  controller: streetController,
                  decoration: _inputDecoration("Street"),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter street name' : null,
                ),
                const SizedBox(height: 12),

                // Building
                TextFormField(
                  controller: buildingController,
                  decoration: _inputDecoration("Building"),
                ),
                const SizedBox(height: 12),

                // Floor
                TextFormField(
                  controller: floorController,
                  decoration: _inputDecoration("Floor"),
                ),
                const SizedBox(height: 12),

                // Apartment
                TextFormField(
                  controller: apartmentController,
                  decoration: _inputDecoration("Apartment"),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Lat: $staticLatitude"),
                    Text("Long: $staticLongitude"),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AddressBloc>().add(
                                    CreateAddressEvent(
                                      cityId: selectedCityId!,
                                      street: streetController.text,
                                      building: buildingController.text,
                                      floor: floorController.text,
                                      apartment: apartmentController.text,
                                      lat: staticLatitude,
                                      long: staticLongitude,
                                    ),
                                  );
                            }
                          },
                    child: isSubmitting
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text("Save Address"),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      );
}
