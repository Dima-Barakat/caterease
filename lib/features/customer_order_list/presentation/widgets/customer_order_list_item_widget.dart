import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/core/widgets/show_custom_snack_bar.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_bloc.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_event.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_state.dart';
import 'package:caterease/features/customer_order_list/presentation/pages/payment_screen.dart';
import 'package:caterease/features/order_details_feature/presentation/pages/order_details_page.dart';
import 'package:caterease/features/restaurants/presentation/widgets/base64_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerOrderListItemWidget extends StatelessWidget {
  final CustomerOrderListEntity order;

  const CustomerOrderListItemWidget({Key? key, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(orderId: order.orderId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.orderId}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  Row(
                    children: [
                      if (order.status != 'confirmed')
                        _buildStatusChip(order.status, Colors.blue)
                      else ...[
                        _buildStatusChip(
                          "Show Bill",
                          Colors.grey,
                          onTap: () {
                            context
                                .read<CustomerOrderListBloc>()
                                .add(GetBill(order.orderId.toString()));
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildStatusChip('\$ Pay', Colors.grey, onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text(
                                  'Choose Payment Method',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                content: const Text(
                                  'Note: To confirm your order, You have to pay either 20% of the total price or the total price ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: [
                                  // Cash Payment Button
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                    ),
                                    icon: const Icon(Icons.attach_money),
                                    label: const Text('Cash Payment'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // Your Cash Payment message code...
                                    },
                                  ),
                                  // E-Payment Button
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                    ),
                                    icon: const Icon(Icons.credit_card),
                                    label: const Text('E-Payment'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentScreen(data: {
                                            "order_id": order.orderId,
                                            "totalPrice": order.totalPrice,
                                          }),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                      ],
                      const SizedBox(width: 8),
                      BlocBuilder<CustomerOrderListBloc,
                          CustomerOrderListState>(
                        builder: (context, state) {
                          bool isDeleting = state is OrderDeleting &&
                              state.orderId == order.orderId;
                          return IconButton(
                            onPressed: isDeleting
                                ? null
                                : () => _showDeleteConfirmation(context),
                            icon: isDeleting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 26,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Delivery Time: ${order.deliveryTime}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Divider(height: 24, thickness: 1),

              // PACKAGES LIST
              Text(
                'Packages:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.packages.length,
                itemBuilder: (context, index) {
                  final package = order.packages[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey[100]!, Colors.grey[300]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: package.photo.isNotEmpty
                            ? Base64ImageWidget(
                                base64String: package.photo,
                                width: 50,
                                height: 50,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 28),
                              ),
                      ),
                      title: Text(
                        package.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${package.branchName}\nPrice: ${package.basePrice}',
                      ),
                    ),
                  );
                },
              ),

              // Delete BUTTON
              if (order.status == 'pending')
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black26,
                      ),
                      onPressed: () async {
                        await _deleteOrder(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

// Reusable gradient status chip
  Widget _buildStatusChip(String label, Color color, {VoidCallback? onTap}) {
    final gradientColors = color == Colors.grey
        ? [Colors.grey[400]!, Colors.grey[600]!]
        : [Color(0xFF64B5F6), Color(0xFF1976D2)];

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Future<void> _deleteOrder(BuildContext context) async {
    debugPrint("=== Submit Button Pressed for Order #${order.orderId} ===");

    try {
      SecureStorage secureStorage = SecureStorage();
      String? token = await secureStorage.getAccessToken();
      debugPrint("Token: $token");

      final url = Uri.parse(
        'http://${ApiConstants.baseUrl}/${order.orderId}',
      );
      debugPrint("Request URL: $url");

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        debugPrint("Decoded Response: $responseBody");

        showCustomSnackBar(context,
            message: 'Order submitted successfully',
            type: SnackBarType.success);

        BlocProvider.of<CustomerOrderListBloc>(context)
            .add(GetCustomerOrderList());
      } else {
        showCustomSnackBar(context,
            message: 'Failed to submit order: ${response.statusCode}',
            type: SnackBarType.error);
      }
    } catch (e) {
      debugPrint("Exception: $e");
      showCustomSnackBar(context,
          message: 'Error to submit order: $e', type: SnackBarType.error);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Order'),
          content:
              Text('Are you sure you want to delete Order #${order.orderId}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<CustomerOrderListBloc>(context)
                    .add(DeleteOrder(orderId: order.orderId));
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
