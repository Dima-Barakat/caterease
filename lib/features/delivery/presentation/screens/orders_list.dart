import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/core/widgets/order_card.dart';
import 'package:caterease/core/widgets/show_custom_snack_bar.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/order/delivery_order_bloc.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/profile/delivery_profile_bloc.dart';
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
  final Map<String, String> statusLabels = {
    "assigned": "⏳ Pending ",
    "accepted": "✅ Accepted",
    "on_the_way": "🛵 On the Way",
    "delivered": "📬 Delivered",
    "rejection": "❌ Cancelled",
  };

  @override
  void initState() {
    super.initState();
    context.read<DeliveryProfileBloc>().add(GetProfileEvent());
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BlocConsumer<DeliveryProfileBloc, DeliveryProfileState>(
              listener: (context, state) {
                if (state is DeliveryProfileError) {
                  showCustomSnackBar(context,
                      message: state.message, type: SnackBarType.error);
                }
              },
              builder: (context, state) {
                if (state is DeliveryProfileLoading) {
                  return const DrawerHeader(
                    decoration: BoxDecoration(color: AppTheme.darkBlue),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                } else if (state is DeliveryProfileLoaded) {
                  final profile = state.profile;
                  return DrawerHeader(
                    decoration: const BoxDecoration(color: AppTheme.darkBlue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.restaurant, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              profile.restaurant.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.drive_eta, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              profile.person.vehicleType,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const DrawerHeader(
                  decoration: BoxDecoration(color: AppTheme.darkBlue),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },

            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DeliveryProfileScreen(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (Route<dynamic> route) => false,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<DeliveryOrderBloc, DeliveryOrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            showCustomSnackBar(context,
                message: state.message, type: SnackBarType.error);
          } else if (state is OrderDeclined) {
            showCustomSnackBar(context,
                message: state.message, type: SnackBarType.info);
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
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
                String statusLabel =
                    statusLabels[order.order.status] ?? order.order.status;
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetails(id: order.order.id),
                      ),
                    );
                  },
                  child: Card(
                    color: AppTheme.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: OrderCard(
                        image: "assets/images/restaurant.png",
                        restaurantName:
                            "${order.restaurant.name}\n${order.restaurant.branch}",
                        status: "Status: $statusLabel",
                        createdSince: order.order.createdSince,
                        isProcessed: order.order.status,
                        onAccept: () {
                          context
                              .read<DeliveryOrderBloc>()
                              .add(AcceptOrder(order.order.id));
                        },
                        onDecline: () async {
                          final reasons = [
                            {
                              "label": "Vehicle Breakdown",
                              "value": "vehicle_breakdown"
                            },
                            {
                              "label": "Vehicle Accident",
                              "value": "vehicle_accident"
                            },
                            {
                              "label": "Stuck in Traffic Jam",
                              "value": "traffic_jam"
                            },
                            {
                              "label": "Health Emergency",
                              "value": "health_emergency"
                            },
                            {
                              "label": "Personal Emergency",
                              "value": "personal_emergency"
                            },
                            {"label": "Other Reason", "value": "other"},
                          ];

                          final selectedReason = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Select Reject Reason"),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: reasons.length,
                                    itemBuilder: (context, index) {
                                      final reason = reasons[index];
                                      return ListTile(
                                        title: Text(reason["label"]!),
                                        onTap: () {
                                          Navigator.pop(
                                              context, reason["value"]);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, null),
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (!mounted) return;

                          if (selectedReason != null &&
                              selectedReason.isNotEmpty) {
                            context.read<DeliveryOrderBloc>().add(
                                  DeclineOrder(order.order.id, selectedReason),
                                );
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            debugPrint("The State is: $state");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Something went wrong!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // 🔹 Trigger reload
                      context
                          .read<DeliveryOrderBloc>()
                          .add(GetAllOrdersEvent());
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text("Reload",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
