import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_bloc.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_event.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_state.dart';
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
    return BlocListener<CustomerOrderListBloc, CustomerOrderListState>(
      listener: (context, state) {
        if (state is OrderDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CustomerOrderListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(orderId: order.orderId),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.orderId}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.status,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
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
                                      color: Colors.red,
                                      size: 24,
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
                const Divider(height: 20, thickness: 1),

                // Packages Section
                Text(
                  'Packages:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
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
                            '${package.branchName}\nPrice: ${package.basePrice}'),
                      ),
                    );
                  },
                ),
                if (order.status == 'pending')
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        print(
                            "=== Submit Button Pressed for Order #${order.orderId} ===");

                        try {
                          SecureStorage secureStorage = SecureStorage();
                          String? token = await secureStorage.getAccessToken();
                          print("Token: $token");

                          final url = Uri.parse(
                            'http://192.168.67.155:8000/api/order/${order.orderId}/submit',
                          );
                          print("Request URL: $url");

                          final response = await http.post(
                            url,
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json',
                            },
                          );

                          print("Response Status: ${response.statusCode}");
                          print("Response Body: ${response.body}");

                          if (response.statusCode == 200) {
                            final responseBody = json.decode(response.body);
                            print("Decoded Response: $responseBody");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(responseBody['message'] ??
                                    'Order submitted successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            BlocProvider.of<CustomerOrderListBloc>(context)
                                .add(GetCustomerOrderList());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to submit order: ${response.statusCode}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          print("Exception: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error submitting order: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
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
