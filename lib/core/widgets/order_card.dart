import 'package:caterease/core/theming/app_theme.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String image;
  final String restaurantName;
  final String message;
  final String createdSince;

  OrderCard({
    super.key,
    required this.image,
    required this.restaurantName,
    required this.message,
    required this.createdSince,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                  buildText(restaurantName, message),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        createdSince,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText(String restaurantName, String message) {
    return Column(
      children: [
        Text(
          restaurantName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(message),
      ],
    );
  }

  Widget elevatedButton(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightGray,
            // side: const BorderSide(color: Colors.purple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
          child: Text(
            text,
            style: TextStyle(color: AppTheme.darkBlue),
          ),
        ),
      ],
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

/* 
class OrderCard extends StatelessWidget {
  final String customerName;
  final String orderNumber;
  final String orderStatus;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.orderStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text("order number : $orderNumber", style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text("status: $orderStatus",
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
 */