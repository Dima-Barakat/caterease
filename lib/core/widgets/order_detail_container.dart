import 'package:flutter/material.dart';

class OrderDetailContainer extends StatelessWidget {
  final String label1;
  final String value1;

  final String label2;
  final String value2;

  final String label3;
  final String value3;

  const OrderDetailContainer({
    super.key,
    required this.label1,
    required this.label2,
    required this.label3,
    required this.value1,
    required this.value2,
    required this.value3,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildInfoRow(label1, value1),
                const SizedBox(height: 16),
                _buildInfoRow(label2, value2),
                const SizedBox(height: 16),
                _buildInfoRow(label3, value3),
              ],
            ),
          ),
        ),
      ],
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
              fontWeight: FontWeight.bold),
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