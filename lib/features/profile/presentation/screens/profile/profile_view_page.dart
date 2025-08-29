import 'package:caterease/core/services/image_service.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
import 'package:caterease/features/profile/domain/entities/address.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_bloc.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_event.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_state.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/profile/profile_bloc.dart';
import 'package:caterease/features/profile/presentation/screens/address/add_address_popup.dart';
import 'package:caterease/features/profile/presentation/screens/profile/profile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({
    super.key,
  });

  @override
  State<ProfileViewPage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileViewPage> {
  final imageService = ImageService();
  final storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              storage.clearAll();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.darkBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.profile;
            return BlocListener<AddressBloc, AddressState>(
              listener: (context, addressState) {
                if (addressState is AddressDeleted) {
                  context.read<ProfileBloc>().add(GetProfileEvent());
                } else if (addressState is AddressError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(addressState.message)),
                  );
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSectionHeader('Personal information', "Edit", () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileEditPage(
                                labels: {
                                  "name": user.name,
                                  "email": user.email,
                                  "phone": user.phone,
                                  "gender": user.gender,
                                },
                              )));
                    }),
                    const SizedBox(height: 12),
                    _buildInfoRow("Full Name", user.name, Icons.person),
                    const SizedBox(height: 4),
                    _buildInfoRow("Email", user.email, Icons.email),
                    const SizedBox(height: 4),
                    _buildInfoRow("Phone Number", user.phone, Icons.phone),
                    const SizedBox(height: 4),
                    _buildInfoRow("Gender",
                        user.gender == 'f' ? 'Female' : 'Male', Icons.wc),
                    const SizedBox(height: 25),
                    _buildSectionHeader('Your Addresses', "Add new address",
                        () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => const AddAddressPopup(),
                      );
                    }),
                    const SizedBox(height: 12),
                    ...user.addresses!.map(
                      (address) => _buildAddressCard(
                        address: address,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildAddressCard({
    required Address address,
  }) {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return InkWell(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.darkBlue.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title (e.g. City + Street)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${address.city}, ${address.street ?? ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.fontBlack,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Optional Switch or Toggle
                    // You can uncomment this if you want to toggle visibility or use another feature

                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context
                            .read<AddressBloc>()
                            .add(DeleteAddressEvent(id: address.id));
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// Address details
                Text(
                  'Building: ${address.building ?? ''}\n Floor: ${address.floor ?? ''}\n apartment: ${address.apartment ?? ''}',
                  style: TextStyle(
                    color: AppTheme.fontBlack.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),

                /// Coordinates
                GestureDetector(
                  onTap: () {
                    if (address.latitude != null && address.longitude != null) {
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
                                    double.tryParse(address.latitude!) ?? 0.0,
                                    double.tryParse(address.longitude!) ?? 0.0,
                                  ),
                                  initialZoom: 15,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.example.cater_ease',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(
                                          double.tryParse(address.latitude!) ??
                                              0.0,
                                          double.tryParse(address.longitude!) ??
                                              0.0,
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
                  },
                  child: const Text(
                    "View Location on Map",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
      String title, String? title2, void Function() onTap) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBlue,
          ),
        ),
        if (title2 != null)
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.darkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                // Icon(icon, size: 18.w, color: color),
                const SizedBox(width: 4),
                Text(
                  title2,
                  style: const TextStyle(
                    color: AppTheme.darkBlue,
                    fontSize: 16,
                  ),
                ),
              ]),
            ),
          )
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.fontBlack.withOpacity(0.7), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.fontBlack.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.fontBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
