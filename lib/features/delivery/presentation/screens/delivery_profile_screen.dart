import 'package:caterease/core/services/image_service.dart';
import 'package:caterease/core/theming/app_theme.dart';
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
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: BlocConsumer<DeliveryProfileBloc, DeliveryProfileState>(
            listener: (context, state) {},
            builder: (context, state) {
              return const Center(
                child: Text('Profile Screen'),
              );
            }));
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
