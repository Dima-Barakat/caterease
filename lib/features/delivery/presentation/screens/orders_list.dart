import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/core/widgets/order_card.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/order/delivery_order_bloc.dart';
import 'package:caterease/features/delivery/presentation/screens/order_details.dart';
import 'package:caterease/features/delivery/presentation/screens/delivery_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  void initState() {
    super.initState();
    context.read<DeliveryOrderBloc>().add(GetAllOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          "Orders",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to any color you want
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.darkBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name
                  Text(
                    'John Doe', // TODO: Replace with your user name variable
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Restaurant name
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'My Restaurant Name', // TODO: Replace with actual
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // Vehicle type
                  Row(
                    children: [
                      Icon(
                        Icons.drive_eta,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(),
                      Text(
                        'Motorbike', // TODO: Replace with actual
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Later implement API logout
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Later implement API logout
              },
            ),
            // Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Later implement API logout
              },
            ),
          ],
        ),
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

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetails(id: order.orderId),
                      ),
                    );
                  },
                  child: Card(
                    color: AppTheme.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          OrderCard(
                            image:
                                "assets/images/restaurant.png", // Placeholder image
                            restaurantName:
                                "${order.restaurantName}\n${order.branchName}",
                            message: "Status: ${order.status}",
                            createdSince: order.createdSince,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Unhandled state: $state'));
          }
        },
      ),
    );
  }
}
