import 'package:caterease/features/cart/presentation/widgets/AnimatedCheckoutButto.dart';
import 'package:caterease/features/restaurants/presentation/widgets/base64_image_widget.dart';
import 'package:caterease/features/packages/presentation/pages/package_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_request.dart';
import 'package:caterease/app_theme.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const GetCartPackagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.darkBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: const SizedBox.shrink(), // هذا يمنع ظهور السهم فقط
        title: const Text("السلة"),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CartBloc>().add(const GetCartPackagesEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is RemoveCartItemSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<CartBloc>().add(const GetCartPackagesEvent());
          } else if (state is UpdateCartItemSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<CartBloc>().add(const GetCartPackagesEvent());
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCartPackagesSuccess) {
            final cartPackages = state.cartPackages;
            if (cartPackages.data.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "السلة فارغة",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // حساب مجموع جميع basePrice:
            double totalBasePrice = 0.0;
            for (var item in cartPackages.data) {
              try {
                totalBasePrice +=
                    double.tryParse(item.basePrice?.toString() ?? "") ?? 0.0;
              } catch (_) {}
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartPackages.data.length,
                    itemBuilder: (context, index) {
                      final item = cartPackages.data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          color: AppTheme.lightGray,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: (item.packageImage != null &&
                                            item.packageImage.isNotEmpty)
                                        ? Base64ImageWidget(
                                            base64String: item.packageImage,
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          )
                                        : Container(
                                            height: 180,
                                            width: double.infinity,
                                            color: AppTheme.lightGray,
                                            child: Icon(
                                              Icons.fastfood,
                                              size: 64,
                                              color: AppTheme.darkBlue
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                  ),
                                  // تاج السعر
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color:
                                            AppTheme.darkBlue.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '\$${item.basePrice ?? ""}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.packageName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: AppTheme.darkBlue,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.packageDescription,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.group,
                                          size: 20,
                                          color: AppTheme.lightGreen,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${item.servesCount ?? ''} serves',
                                          style: TextStyle(
                                            color: AppTheme.darkBlue,
                                          ),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () {
                                            _navigateToEditPage(context, item);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppTheme.lightGreen,
                                            foregroundColor: AppTheme.darkBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text('تعديل'),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red,
                                          tooltip: 'حذف',
                                          onPressed: () =>
                                              _showDeleteConfirmation(
                                                  context, item.cartItemId),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Checkout button + المجموع
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: AnimatedCheckoutButton(
                    enabled: cartPackages.data.isNotEmpty,
                    label:
                        "متابعة للدفع  (\$${totalBasePrice.toStringAsFixed(2)})",
                    onPressed: cartPackages.data.isNotEmpty
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "المجموع الكلي: \$${totalBasePrice.toStringAsFixed(2)}"),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("حدث خطأ في تحميل السلة"),
            );
          }
        },
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, dynamic item) {
    final int cartItemId = item.cartItemId;
    final String packageId =
        item.packageId.toString(); // Keep packageId as string
    print(
        "Navigating to edit page with cartItemId: $cartItemId and packageId: $packageId");

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PackageEditPage(
          packageId: int.tryParse(packageId) ??
              0, // Pass packageId as int, default to 0 if parsing fails
          cartItem: item,
          isEditMode: true,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذا العنصر من السلة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<CartBloc>()
                  .add(RemoveCartItemEvent(cartItemId: itemId));
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }
}
