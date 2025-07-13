import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/core/widgets/order_card.dart';
import 'package:caterease/core/widgets/order_detail_container.dart';

import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        leading: IconButton(onPressed: () { Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                OrderDetailContainer(
                  orderNumber: '#1234567890',
                  status: 'Delivered',
                ),
                SizedBox(
                  height: 15,
                ),
                const Text(
                  'User information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
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
                        _buildInfoRow('client name', "name"),
                        const SizedBox(height: 16),
                        _buildInfoRow(' phone', "phone"),
                        const SizedBox(height: 16),
                        _buildInfoRow('address', "address"),
                      ],
                    ),
                  ),
                )
                /*     UserInfoCard(
              name: 'أحمد محمد',
              phone: '0501234567',
              address: 'الرياض، حي النرجس، شارع 123',
            ),
             */
              ]),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF314E76),
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
