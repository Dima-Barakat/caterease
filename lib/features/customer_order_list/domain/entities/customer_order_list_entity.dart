import 'package:equatable/equatable.dart';
import 'package:caterease/features/customer_order_list/domain/entities/package_entity.dart';

class CustomerOrderListEntity extends Equatable {
  final int orderId;
  final String status;
  final String deliveryTime;
  final List<PackageEntity> packages;

  const CustomerOrderListEntity({
    required this.orderId,
    required this.status,
    required this.deliveryTime,
    required this.packages,
  });

  @override
  List<Object?> get props => [orderId, status, deliveryTime, packages];
}


