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
      body: BlocBuilder<CustomerOrderListBloc, CustomerOrderListState>(
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
    );
  }
}
