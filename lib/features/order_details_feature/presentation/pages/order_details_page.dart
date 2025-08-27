import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/order_details_feature/domain/entities/order_details_entity.dart';
import 'package:caterease/features/order_details_feature/presentation/bloc/order_details_bloc.dart';
import 'package:caterease/features/restaurants/presentation/widgets/base64_image_widget.dart';
import 'package:caterease/injection_container.dart';
import 'package:caterease/core/theming/app_theme.dart';

class OrderDetailsPage extends StatelessWidget {
  final int orderId;

  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text(
          'تفاصيل الطلب',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: BlocProvider(
        create: (_) =>
            sl<OrderDetailsBloc>()..add(GetOrderDetails(orderId: orderId)),
        child: BlocConsumer<OrderDetailsBloc, OrderDetailsState>(
          listener: (context, state) {
            if (state is OrderDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return _buildLoadingState();
            } else if (state is OrderDetailsLoaded) {
              return _buildOrderDetails(context, state.orderDetails);
            } else if (state is OrderDetailsError) {
              return _buildErrorState(context, state.message);
            } else {
              return const Center(
                child: Text('يرجى تحميل تفاصيل الطلب'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.darkBlue),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل تفاصيل الطلب...',
            style: TextStyle(
              color: AppTheme.fontBlack.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.fontBlack.withOpacity(0.6)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context
                  .read<OrderDetailsBloc>()
                  .add(GetOrderDetails(orderId: orderId));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, OrderDetailsEntity order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            context,
            title: 'معلومات الطلب',
            icon: Icons.receipt_long,
            children: [
              _infoTile(Icons.confirmation_number, 'الحالة', order.status,
                  statusColor(order.status)),
              _infoTile(Icons.check_circle, 'تمت الموافقة',
                  order.isApproved ? 'نعم' : 'لا', null),
              _infoTile(Icons.timer, 'وقت التوصيل', order.deliveryTime, null),
              _infoTile(Icons.attach_money, 'السعر الإجمالي',
                  '\$${order.totalPrice}', AppTheme.lightGreen),
              if (order.notes != null)
                _infoTile(Icons.note, 'ملاحظات', order.notes!, null),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: 'العنوان',
            icon: Icons.location_on,
            children: [
              _infoTile(
                  Icons.location_on, 'الشارع', order.address.street, null),
              _infoTile(Icons.home, 'المبنى', order.address.building, null),
              _infoTile(
                  Icons.location_city, 'المدينة', order.address.city, null),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, right: 8),
            child: Text(
              'الباقات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
            ),
          ),
          ...order.packages.map((pkg) => _buildPackageCard(context, pkg)),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: AppTheme.darkBlue.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.darkBlue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBlue,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
      IconData icon, String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.darkBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.darkBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.fontBlack)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? AppTheme.fontBlack,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, PackageEntity pkg) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: AppTheme.darkBlue.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pkg.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: (pkg.photo != null && pkg.photo.isNotEmpty)
                    ? Base64ImageWidget(
                        base64String: pkg.photo,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported_outlined,
                            size: 50, color: AppTheme.fontBlack),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            _packageInfoTile(Icons.restaurant, 'المطعم', pkg.restaurantName),
            _packageInfoTile(Icons.description, 'الوصف', pkg.description),
            _packageInfoTile(
                Icons.monetization_on, 'السعر الأساسي', '\$${pkg.basePrice}'),
            _packageInfoTile(
                Icons.format_list_numbered, 'الكمية', pkg.quantity.toString()),
            _packageInfoTile(
                Icons.group, 'عدد الأشخاص', pkg.servesCount.toString()),
            _packageInfoTile(
                Icons.person_add, 'أشخاص إضافيون', pkg.extraPersons.toString()),
            _packageInfoTile(Icons.attach_money, 'سعر للشخص الإضافي',
                '\$${pkg.pricePerExtraPerson}'),
            _packageInfoTile(Icons.calculate, 'تكلفة الأشخاص الإضافيين',
                '\$${pkg.extraPersonsCost}'),
            _packageInfoTile(
                Icons.people, 'إجمالي الأشخاص', pkg.totalPersons.toString()),
            _packageInfoTile(Icons.security, 'مطلوب دفعة مسبقة',
                pkg.prepaymentRequired ? 'نعم' : 'لا'),
            _packageInfoTile(Icons.percent, 'نسبة الدفعة المسبقة',
                '${pkg.prepaymentPercentage}%'),
            _packageInfoTile(Icons.payment, 'مبلغ الدفعة المسبقة',
                '\$${pkg.prepaymentAmount}'),
            _packageInfoTile(
                Icons.policy, 'سياسة الإلغاء', pkg.cancellationPolicy),
            _packageInfoTile(
                Icons.celebration, 'نوع المناسبة', pkg.occasionType),
            const SizedBox(height: 16),
            _buildSectionTitle('الأصناف', Icons.fastfood),
            ...pkg.items.map((item) => _listItem(
                Icons.fastfood, '${item.foodItemName} (x${item.quantity})')),
            const SizedBox(height: 16),
            _buildSectionTitle('الخدمات', Icons.room_service),
            ...pkg.services.map((service) => _listItem(Icons.room_service,
                '${service.name} - \$${service.customPrice}')),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.darkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.summarize, color: AppTheme.darkBlue),
                  const SizedBox(width: 12),
                  Text('الإجمالي النهائي:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBlue)),
                  const Spacer(),
                  Text('\$${pkg.finalTotal}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightGreen)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.darkBlue, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: AppTheme.fontBlack),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.darkBlue),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlue)),
        ],
      ),
    );
  }

  Widget _listItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.fontBlack.withOpacity(0.6)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'مكتمل':
        return AppTheme.lightGreen;
      case 'قيد التجهيز':
        return AppTheme.lightBlue;
      case 'ملغي':
        return Colors.redAccent;
      default:
        return AppTheme.fontBlack;
    }
  }
}
