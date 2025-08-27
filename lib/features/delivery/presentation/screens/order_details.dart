import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/core/widgets/info_card.dart';
import 'package:caterease/core/widgets/qr_scanner_screen.dart';
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
    context.read<DeliveryOrderBloc>().add(GetOrderDetailsEvent(id: widget.id));
  }

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
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            final orderData = state.order; // This is our new Order entity

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
                        MapEntry("Order number", orderData.order.id.toString()),
                        MapEntry("Status", orderData.order.status),
                        MapEntry("Items", orderData.order.items ?? ""),
                        MapEntry("Date",
                            "${orderData.order.createdAt} (${orderData.order.createdSince})"),
                      ],
                    ),
                    const SizedBox(height: 15),

                    //: User info
                    InfoCard(
                      title: "User Information",
                      details: [
                        MapEntry("Name", orderData.user.name),
                        MapEntry("Phone", orderData.user.phone),
                        MapEntry(
                            "Address",
                            'Building: ${orderData.user.address.building ?? ''} - '
                                'Floor: ${orderData.user.address.floor ?? ''} - '
                                'Apartment: ${orderData.user.address.apartment ?? ''}'),
                      ],
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

                    //: start delivery
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

                    const SizedBox(height: 30),

                    //: QR Scanner button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final scanned = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QRScannerPage(),
                            ),
                          );

                          if (scanned != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('QR accepted: $scanned'),
                                backgroundColor: AppTheme.lightGreen,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.qr_code_scanner,
                            color: Colors.white),
                        label: const Text(
                          ' Scan the QR code to confirm receipt',
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
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
