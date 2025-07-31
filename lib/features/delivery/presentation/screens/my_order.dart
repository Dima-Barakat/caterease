import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/core/widgets/order_card.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/delivery_order_bloc.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  void initState() {
    super.initState();
    context.read<DeliveryOrderBloc>().add(GetAllOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
      ),
      body: BlocConsumer<DeliveryOrderBloc, DeliveryOrderState>(
        listener: (context, state) => {},
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is OrderListLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return const Center(child: Text("No orders available."));
            }

            return ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  color: AppTheme.lightBlue,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: OrderCard(
                      image:
                          "assets/images/restaurant.png", // Placeholder image
                      restaurantName: order.restaurantName,
                      message: "Status: ${order.status}",
                      text: "Total: \$${order.totalPrice}",
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox(); // Initial state
          }
        },
      ),
    );
  }
}
