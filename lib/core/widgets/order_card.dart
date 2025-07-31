import 'package:caterease/core/theming/app_theme.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String image;
  final String restaurantName;
  final String message;
  final String text;

  OrderCard(
      {super.key,
      required this.image,
      required this.restaurantName,
      required this.message,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
                  elevatedButton(text)
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
        const Text(
          '2h',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
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
