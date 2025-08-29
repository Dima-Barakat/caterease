import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/core/widgets/info_card.dart';
import 'package:caterease/core/widgets/qr_scanner_screen.dart';
import 'package:caterease/core/widgets/show_custom_snack_bar.dart';
import 'package:caterease/core/widgets/user_info_card.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/order/delivery_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetails extends StatefulWidget {
  final int id;
  const OrderDetails({super.key, required this.id});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    super.initState();
    context.read<DeliveryOrderBloc>().add(GetOrderDetailsEvent(widget.id));
  }

  final Map<String, String> statusLabels = {
    "assigned": "⏳ Pending Confirmation ",
    "accepted": "✅ Accepted",
    "on_the_way": "🛵 On the Way",
    "delivered": "📬 Delivered",
    "rejection": "❌ Cancelled",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.fontBlack),
          onPressed: () {
            context.read<DeliveryOrderBloc>().add(GetAllOrdersEvent());
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<DeliveryOrderBloc, DeliveryOrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is OrderAccepted) {
            showCustomSnackBar(context,
                message: state.message, type: SnackBarType.success);
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            final orderData = state.order;
            String statusLabel =
                statusLabels[orderData.order.status] ?? orderData.order.status;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //: Order info
                      InfoCard(
                        title: "Order Information",
                        details: [
                          MapEntry(
                              "Order number", orderData.order.id.toString()),
                          MapEntry("Status", statusLabel),
                          MapEntry("Items", orderData.order.items ?? ""),
                          MapEntry("Date",
                              "${orderData.order.createdAt} (${orderData.order.createdSince})"),
                        ],
                      ),
                      const SizedBox(height: 15),

                      //: User info
                      UserInfoCard(
                        title: "User Information",
                        details: [
                          MapEntry("Name", orderData.user.name),
                          MapEntry("Phone", orderData.user.phone),
                          MapEntry(
                              "Address",
                              '${orderData.user.address.city}\t${orderData.user.address.district} \t ${orderData.user.address.area} \n'
                                  'Street:${orderData.user.address.street ?? ''}\n'
                                  'Building: ${orderData.user.address.building ?? ''}\n'
                                  'Floor: ${orderData.user.address.floor ?? ''}\n'
                                  'Apartment: ${orderData.user.address.apartment ?? ''}'),
                        ],
                        longitude: orderData.user.address.longitude,
                        latitude: orderData.user.address.latitude,
                      ),
                      const SizedBox(height: 15),

                      //: Restaurant info
                      InfoCard(
                        title: "Restaurant Information",
                        details: [
                          MapEntry("Name", orderData.restaurant.name),
                          MapEntry("Branch", orderData.restaurant.branch),
                          MapEntry(
                              "location", orderData.restaurant.location ?? ""),
                        ],
                      ),
                      const SizedBox(height: 30),

                      //: Accept order
                      if (state.order.order.status == 'assigned')
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              context
                                  .read<DeliveryOrderBloc>()
                                  .add(AcceptOrder(state.order.order.id));

                              context.read<DeliveryOrderBloc>().add(
                                  GetOrderDetailsEvent(state.order.order.id));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.darkBlue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                minimumSize: const Size(80, 36)),
                            child: const Text("Accept",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                        ),

                      //: start delivery
                      if (state.order.order.status == 'accepted')
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              context.read<DeliveryOrderBloc>().add(
                                    UpdateStatusOrderEvent(
                                        state.order.order.id, "on_the_way"),
                                  );
                            },
                            icon: const Icon(Icons.delivery_dining,
                                color: Colors.white),
                            label: const Text(
                              ' Start delivery',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                            ),
                          ),
                        ),

                      //: QR Scanner button
                      if (state.order.order.status == 'on_the_way')
                        Center(
                          child: // QR Scanner
                              ElevatedButton.icon(
                            onPressed: () async {
                              final scanned = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => QRScannerPage(
                                          id: state.order.order.id,
                                        )),
                              );
                              if (scanned != null) {
                                // Optionally: show a SnackBar instead of another dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Delivery confirmed: $scanned'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                // You can also call a Bloc event here if needed
                              }
                            },
                            icon: const Icon(Icons.qr_code_scanner,
                                color: Colors.white),
                            label: const Text(
                              'Scan QR code to confirm delivery',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                            ),
                          ),
                        ),
                    ]),
              ),
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
                          .add(GetOrderDetailsEvent(widget.id));
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
