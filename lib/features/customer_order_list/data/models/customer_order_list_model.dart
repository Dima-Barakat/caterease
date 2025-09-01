import 'package:caterease/features/customer_order_list/data/models/package_model.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';

class CustomerOrderListModel extends CustomerOrderListEntity {
  const CustomerOrderListModel({
    required super.orderId,
    String? status,
    String? deliveryTime,
    required super.totalPrice,
    required List<PackageModel> super.packages,
  }) : super(
          status: status ?? "", // قيمة افتراضية لو null
          deliveryTime: deliveryTime ?? "",
        );

  factory CustomerOrderListModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderListModel(
      orderId: json["order_id"] ?? 0,
      status: json["status"] as String?,
      totalPrice: json["total_price"] as double,
      deliveryTime: json["delivery_time"] as String?,
      packages: (json["packages"] as List? ?? [])
          .map((e) => PackageModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId,
      "status": status,
      "delivery_time": deliveryTime,
      "packages": packages.map((x) => (x as PackageModel).toJson()).toList(),
    };
  }
}
