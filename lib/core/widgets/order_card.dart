import 'package:caterease/core/theming/app_theme.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String image;
  final String restaurantName;
  final String status;
  final String createdSince;
  final String isProcessed;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const OrderCard(
      {super.key,
      required this.image,
      required this.restaurantName,
      required this.status,
      required this.createdSince,
      required this.isProcessed,
      required this.onAccept,
      required this.onDecline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.restaurant, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(status),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      createdSince,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isProcessed == 'assigned')
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onDecline,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightGray,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      minimumSize: const Size(80, 36)),
                  child: const Text("Reject",
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class OrderInfoCard extends StatelessWidget {
  final String orderNumber;
  final String status;

  const OrderInfoCard({
    super.key,
    required this.orderNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE6E6E6)),
              bottom: BorderSide(color: Color(0xFFE6E6E6)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                _buildInfoRow('Order Number', orderNumber),
                const SizedBox(height: 16),
                _buildInfoRow('Status', status),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF314E76),
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
