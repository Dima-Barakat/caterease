import 'package:caterease/core/services/location_picker.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_bloc.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_event.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_state.dart';
import 'package:caterease/features/profile/presentation/screens/profile/profile_view_page.dart';
import 'package:latlong2/latlong.dart';
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
  String? selectedDistrictId;
  String? selectedAreaId;

  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> areas = [];

  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();

  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadCitiesEvent());
  }

  @override
  void dispose() {
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressLoading) {
          setState(() => isSubmitting = true);
        } else {
          setState(() => isSubmitting = false);
        }

        if (state is CitiesLoaded) {
          setState(() => cities = state.cities);
          debugPrint(cities.toString());
        }

        if (state is DistrictsLoaded) {
          setState(() => districts = state.districts);
          debugPrint(districts.toString());
        }

        if (state is AreasLoaded) {
          setState(() => areas = state.areas);
          debugPrint(areas.toString());
        }

        if (state is AddressCreated) {
          Navigator.of(context).pop();
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
      builder: (context, state) {
        return Padding(
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

                  // 🔹 City Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCityId,
                    decoration: _inputDecoration("Select City"),
                    items: cities.map((city) {
                      return DropdownMenuItem(
                        value: city['id'].toString(),
                        child: Text(city['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCityId = value;
                        selectedDistrictId = null;
                        selectedAreaId = null;
                        districts.clear();
                        areas.clear();
                      });
                      if (value != null) {
                        context
                            .read<AddressBloc>()
                            .add(LoadDistrictsEvent(cityId: value));
                      }
                    },
                    validator: (value) =>
                        value == null ? 'Please select a city' : null,
                  ),
                  const SizedBox(height: 12),

                  // 🔹 District Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedDistrictId,
                    decoration: _inputDecoration("Select District"),
                    items: districts.map((district) {
                      return DropdownMenuItem(
                        value: district['id'].toString(),
                        child: Text(district['name']),
                      );
                    }).toList(),
                    onChanged: districts.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              selectedDistrictId = value;
                              selectedAreaId = null;
                              areas.clear();
                            });
                            if (value != null) {
                              context
                                  .read<AddressBloc>()
                                  .add(LoadAreasEvent(districtId: value));
                            }
                          },
                    validator: (value) =>
                        value == null ? 'Please select a district' : null,
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Area Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedAreaId,
                    decoration: _inputDecoration("Select Area"),
                    items: areas.map((area) {
                      return DropdownMenuItem(
                        value: area['id'].toString(),
                        child: Text(area['name']),
                      );
                    }).toList(),
                    onChanged: areas.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              selectedAreaId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: streetController,
                    decoration: _inputDecoration("Street"),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter street name' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: buildingController,
                    decoration: _inputDecoration("Building"),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: floorController,
                    decoration: _inputDecoration("Floor"),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: apartmentController,
                    decoration: _inputDecoration("Apartment"),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final pickedLocation =
                            await LocationPicker.pickLocation(
                          context,
                          initialLocation: selectedLatitude != null &&
                                  selectedLongitude != null
                              ? LatLng(selectedLatitude!, selectedLongitude!)
                              : null,
                        );

                        if (pickedLocation != null) {
                          setState(() {
                            selectedLatitude = pickedLocation.latitude;
                            selectedLongitude = pickedLocation.longitude;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Location Selected: ${pickedLocation.latitude}, ${pickedLocation.longitude}"),
                            ),
                          );
                        }
                      },
                      child: const Text("Pick Location on Map"),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Save Address Button
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
                                        districtId: selectedDistrictId!,
                                        areaId: selectedAreaId,
                                        street: streetController.text,
                                        building: buildingController.text,
                                        floor: floorController.text,
                                        apartment: apartmentController.text,
                                        lat: selectedLatitude?.toString(),
                                        long: selectedLongitude?.toString(),
                                      ),
                                    );
                              }
                            },
                      child: isSubmitting
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text("Save Address"),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
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
