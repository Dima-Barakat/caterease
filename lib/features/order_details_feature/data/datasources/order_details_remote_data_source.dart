import 'package:caterease/features/order_details_feature/data/models/order_details_model.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<OrderDetailsModel> getOrderDetails(int orderId);
}
