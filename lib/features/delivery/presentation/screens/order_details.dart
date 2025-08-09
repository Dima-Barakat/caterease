import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/core/widgets/order_detail_container.dart';
import 'package:caterease/core/widgets/qr_scanner_screen.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/delivery_order_bloc.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.fontBlack),
          onPressed: () {
            // Dispatch reset event
            context.read<DeliveryOrderBloc>().add(GetAllOrdersEvent());
            // Pop the screen
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<DeliveryOrderBloc, DeliveryOrderState>(
          listener: (context, state) => {
                if (state is OrderError)
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)))
              },
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              final order = state.order;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        OrderDetailContainer(
                          label1: 'Order number',
                          value1: order.orderId.toString(),
                          label2: 'Status',
                          value2: order.status,
                          label3: 'Items',
                          value3: order.items!,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'User information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        OrderDetailContainer(
                          label1: 'Name',
                          value1: order.customerName,
                          label2: 'Phone',
                          value2: '09366123456',
                          label3: 'Address',
                          value3:
                              'Building: ${order.address!.building ?? ''} - Floor: ${order.address!.floor ?? ''} - apartment: ${order.address!.apartment ?? ''}',
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Restaurant information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        OrderDetailContainer(
                          label1: 'Name',
                          value1: order.restaurantName,
                          label2: 'Phone',
                          value2: '011 78123456',
                          label3: 'branch',
                          value3: order.branchName,
                        ),
                        const SizedBox(height: 30),
                        // QR Scanner
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final scanned = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const QRScannerPage()),
                              );

                              if (scanned != null) {
                                // Optionally: show a SnackBar instead of another dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'تم تأكيد الاستلام بالرمز: $scanned'),
                                    backgroundColor: AppTheme.lightGreen,
                                  ),
                                );

                                // You can also call a Bloc event here if needed
                                // context.read<OrdersBloc>().add(ConfirmReceiptEvent(code: scanned));
                              }
                            },
                            icon: const Icon(Icons.qr_code_scanner,
                                color: Colors.white),
                            label: const Text(
                              '  امسح رمز QR لتأكيد الاستلام',
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
            }
            return const SizedBox();
          }),
    );
  }
}
