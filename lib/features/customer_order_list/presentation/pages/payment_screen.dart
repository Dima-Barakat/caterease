import 'package:caterease/core/widgets/show_custom_snack_bar.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_bloc.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_event.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const PaymentScreen({super.key, required this.data});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CardFieldInputDetails? _cardDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: BlocConsumer<CustomerOrderListBloc, CustomerOrderListState>(
        listener: (context, state) async {
          if (state is SuccessEPayment) {
            final clientSecret = state.data;
            print("data of widget:  ${widget.data}");

            try {
              // Stripe payment confirmation
              await Stripe.instance.confirmPayment(
                paymentIntentClientSecret: clientSecret,
                data: const PaymentMethodParams.card(
                  paymentMethodData: PaymentMethodData(
                    billingDetails: BillingDetails(
                      email: 'customer@example.com',
                    ),
                  ),
                ),
              );
              print("\n\n Payment done \n\n");

              context.read<CustomerOrderListBloc>().add(PayOrder(
                  amount: widget.data['totalPrice'],
                  billId: widget.data['order_id'].toString(),
                  paymentMethod: 'partial',
                  paymentType: 'electronic'));

              print('\n\n bill payment done \n\n');
              showCustomSnackBar(context,
                  message: 'Payment successful!', type: SnackBarType.success);
            } catch (e) {
              print('Stripe error: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stripe error: $e')),
              );
            }
          }

          if (state is ErrorEPayment) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment failed: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoadingEPayment;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                  const SizedBox(height: 24),
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CardField(
                      onCardChanged: (cardDetails) {
                        setState(() => _cardDetails = cardDetails);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading || _cardDetails?.complete != true
                          ? null
                          : () {
                              context.read<CustomerOrderListBloc>().add(
                                    EPayment(
                                        amount:
                                            (widget.data['totalPrice']) * 100),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Full Payment'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading || _cardDetails?.complete != true
                          ? null
                          : () {
                              context.read<CustomerOrderListBloc>().add(
                                    EPayment(
                                        amount: (widget.data['totalPrice']) *
                                            2000 /
                                            100),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Partial Payment'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(color: Colors.grey.shade600)),
              Text('\$${widget.data['totalPrice'].toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax', style: TextStyle(color: Colors.grey.shade600)),
              Text('\$0', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('\$${widget.data['totalPrice'].toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('20% of the Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                  '\$${(widget.data['totalPrice'] * 20 / 100).toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor)),
            ],
          ),
        ],
      ),
    );
  }
}
