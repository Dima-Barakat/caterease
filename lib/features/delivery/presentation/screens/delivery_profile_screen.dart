import 'package:caterease/core/services/image_service.dart';
import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/order/delivery_order_bloc.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/profile/delivery_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryProfileScreen extends StatefulWidget {
  const DeliveryProfileScreen({
    super.key,
  });

  @override
  State<DeliveryProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<DeliveryProfileScreen> {
  final imageService = ImageService();

  @override
  void initState() {
    super.initState();
    context.read<DeliveryProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.fontBlack),
          onPressed: () {
            context.read<DeliveryOrderBloc>().add(GetAllOrdersEvent());
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<DeliveryProfileBloc, DeliveryProfileState>(
        listener: (context, state) {
          if (state is DeliveryProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DeliveryProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DeliveryProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //: USER INFO
                  _buildSectionHeader('User Information', null, () {}),
                  const SizedBox(height: 12),
                  _buildInfoRow("Full Name", profile.user.name, Icons.person),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      "Phone Number", profile.user.phone, Icons.phone),
                  if (profile.user.email.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildInfoRow("Email", profile.user.email, Icons.email),
                  ],
                  if (profile.user.gender.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      "Gender",
                      profile.user.gender == 'f' ? 'Female' : 'Male',
                      Icons.wc,
                    ),
                  ],

                  const SizedBox(height: 25),

                  //: RESTAURANT INFO
                  _buildSectionHeader('Restaurant Information', null, () {}),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                      "Name", profile.restaurant.name, Icons.restaurant),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      "Branch", profile.restaurant.description, Icons.store),

                  const SizedBox(height: 25),

                  //: VEHICLE INFO
                  _buildSectionHeader('Vehicle Information', null, () {}),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    "Vehicle Type",
                    profile.person.vehicleType,
                    Icons.drive_eta,
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            );
          } else {
            //: ERROR OR UNKNOWN STATE
            return Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Failed to load profile.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<DeliveryProfileBloc>()
                          .add(GetProfileEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reload"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
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
