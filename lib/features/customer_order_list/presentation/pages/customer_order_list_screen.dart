import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_bloc.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_event.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_state.dart';
import 'package:caterease/features/customer_order_list/presentation/widgets/customer_order_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerOrderListScreen extends StatefulWidget {
  const CustomerOrderListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerOrderListScreen> createState() =>
      _CustomerOrderListScreenState();
}

class _CustomerOrderListScreenState extends State<CustomerOrderListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CustomerOrderListBloc>(context).add(GetCustomerOrderList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: BlocListener<CustomerOrderListBloc, CustomerOrderListState>(
        listener: (context, state) {
          if (state is OrderDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is CustomerOrderListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is CouponSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coupon applied successfully!')),
            );
          } else if (state is SuccessBill) {
            final bill = state.bill;
            showDialog(
              context: context,
              builder: (dialogContext) {
                final TextEditingController couponController =
                    TextEditingController();

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Bill #${bill.billId}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBillDetail("Order ID", bill.orderId.toString()),
                        _buildBillDetail(
                            "Prepayment", "${bill.prepaymentPercentage}%"),
                        _buildBillDetail(
                            "Prepayment Amount", "\$${bill.prepaymentAmount}"),
                        _buildBillDetail(
                            "Total Amount", "\$${bill.totalAmount}"),
                        _buildBillDetail("Status", bill.status),
                        const Divider(height: 30, thickness: 1),

                        // 🔥 Coupon Input Section
                        const Text(
                          "Coupon Code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: couponController,
                          decoration: InputDecoration(
                            hintText: "Enter coupon code",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle),
                          label: const Text("Use Coupon"),
                          onPressed: () {
                            final couponCode = couponController.text.trim();
                            if (couponCode.isNotEmpty) {
                              // 🔥 Dispatch your Bloc Event here
                              context.read<CustomerOrderListBloc>().add(
                                    ApplyCouponEvent(
                                      orderId: bill.billId,
                                      coupon: couponCode,
                                    ),
                                  );
                              Navigator.of(dialogContext).pop(); // Close dialog
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a coupon code"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const CustomerOrderListScreen(),
                          ),
                        );
                      },
                      child: const Text("Back to Orders"),
                    ),
                  ],
                );
              },
            );
          } else if (state is ErrorBill) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<CustomerOrderListBloc, CustomerOrderListState>(
          builder: (context, state) {
            if (state is CustomerOrderListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomerOrderListLoaded) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return CustomerOrderListItemWidget(order: order);
                },
              );
            } else if (state is CustomerOrderListError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No orders found.'));
          },
        ),
      ),
    );
  }

  Widget _buildBillDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
