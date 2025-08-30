import 'dart:convert';
import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_request.dart'
    as CartRequest;
import 'package:caterease/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/packages/domain/entities/discount.dart';
import 'package:caterease/features/packages/domain/entities/package_detail.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_event.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_state.dart';

class PackageDetailWidget extends StatefulWidget {
  final PackageDetail packageDetail;

  const PackageDetailWidget({Key? key, required this.packageDetail})
      : super(key: key);

  @override
  State<PackageDetailWidget> createState() => _PackageDetailWidgetState();
}

class _PackageDetailWidgetState extends State<PackageDetailWidget> {
  List<ServiceType> selectedServiceTypes = [];
  List<OccasionType> selectedOccasionTypes = [];
  int extraPersons = 0;
  List<PackageExtra> selectedExtras = [];
  double totalPrice = 0.0;
  bool isOrderValid = false;

  @override
  void initState() {
    super.initState();
    selectedServiceTypes = List.from(widget.packageDetail.serviceType);
    if (widget.packageDetail.occasionTypes.isNotEmpty) {
      selectedOccasionTypes = [widget.packageDetail.occasionTypes.first];
    }
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    final base = widget.packageDetail.basePrice ?? 0.0;
    final serviceCost =
        selectedServiceTypes.fold(0.0, (s, e) => s + (e.serviceCost ?? 0.0));
    final extrasCost = selectedExtras.fold(0.0, (s, e) => s + (e.price ?? 0.0));
    final personsCost =
        extraPersons * (widget.packageDetail.pricePerExtraPerson ?? 0.0);

    // Calculate total before discount
    double totalBeforeDiscount = base + serviceCost + extrasCost + personsCost;

    // Apply discount only to base items (non-optional items)
    double discountAmount = 0.0;
    if (widget.packageDetail.discount != null) {
      // Calculate base items cost (only non-optional items)
      double baseItemsCost = base;

      // Parse discount percentage
      String discountValue = widget.packageDetail.discount!.value;
      if (discountValue.endsWith("%")) {
        double discountPercentage =
            double.tryParse(discountValue.replaceAll("%", "")) ?? 0.0;
        discountAmount = (baseItemsCost * discountPercentage) / 100;
      }
    }

    setState(() {
      // Use final_price if available, otherwise calculate with discount
      if (widget.packageDetail.finalPrice != null) {
        totalPrice = widget.packageDetail.finalPrice! +
            serviceCost +
            extrasCost +
            personsCost;
      } else {
        totalPrice = totalBeforeDiscount - discountAmount;
      }

      isOrderValid =
          selectedServiceTypes.isNotEmpty && selectedOccasionTypes.isNotEmpty;
    });
  }

  void _confirmOrder() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Package Confirmation", textAlign: TextAlign.start),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Package: ${widget.packageDetail.name}"),
            const Divider(),
            Text(
                "Services: ${selectedServiceTypes.map((e) => e.name).join(", ")}"),
            Text(
                "Occasion: ${selectedOccasionTypes.map((e) => e.name).join(", ")}"),
            if (extraPersons > 0) Text("Extra Persons: $extraPersons"),
            if (selectedExtras.isNotEmpty)
              Text("Extras: ${selectedExtras.map((e) => e.name).join(", ")}"),
            if (widget.packageDetail.discount != null) ...[
              const SizedBox(height: 8),
              Text(
                  "Discount: ${widget.packageDetail.discount!.value} - ${widget.packageDetail.discount!.description}",
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 12),
            Text("Total: \$${totalPrice.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final request = CartRequest.AddToCartRequest(
                  packageId: widget.packageDetail.id.toString(),
                  quantity: 1, // Assuming quantity is always 1 for a package
                  extraPersons: extraPersons,
                  occasionTypeId: selectedOccasionTypes.first.id,
                  serviceType: selectedServiceTypes
                      .map((e) => CartRequest.ServiceType(id: e.id))
                      .toList(),
                  extras: selectedExtras
                      .map((e) => CartRequest.Extra(extraId: e.id, quantity: 1))
                      .toList(), // Assuming quantity is 1 for each extra
                );
                print(
                    'AddToCartRequest: ${request.toString()}'); // Add this line
                context.read<CartBloc>().add(AddToCartEvent(request: request));
              },
              child: const Text("Confirm")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text("Package Details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Adding to cart...")),
            );
          } else if (state is AddToCartSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response.message)),
            );
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _packageImage(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          widget.packageDetail.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _infoSection(),
                    const SizedBox(height: 16),
                    _selectionSection(
                        "Service Type", Icons.room_service, _serviceChips()),
                    const SizedBox(height: 16),
                    _selectionSection(
                        "Occasion", Icons.event, _occasionChips()),
                    const SizedBox(height: 16),
                    _sliderSection(),
                    const SizedBox(height: 16),
                    _checkboxSection(),
                    const SizedBox(height: 16),
                    _itemsSection(),
                    const SizedBox(height: 24),
                    _totalAndButton(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _packageImage() {
    final photo = widget.packageDetail.photo;
    if (photo.startsWith("data:image")) {
      try {
        final b = base64Decode(photo.split(",").last);
        return Image.memory(b, fit: BoxFit.cover);
      } catch (_) {}
    }
    return Image.network(
      widget.packageDetail.photo,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(color: Colors.grey),
    );
  }

  Widget _infoSection() {
    final pd = widget.packageDetail;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Serves: ${pd.servesCount} person"),
            const SizedBox(height: 8),
            // Show base price with strikethrough only if final_price exists
            if (pd.finalPrice != null) ...[
              Row(
                children: [
                  Text(
                    "Original: \$${(pd.basePrice ?? 0.0).toStringAsFixed(2)}",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Final: \$${pd.finalPrice!.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text("Base Price: \$${(pd.basePrice ?? 0.0).toStringAsFixed(2)}"),
            ],
            const SizedBox(height: 8),
            Text("Branch: ${pd.branchName}"),
            if (pd.prepaymentRequired) ...[
              const SizedBox(height: 8),
              Text(
                  "Prepayment: \$${(pd.prepaymentAmount ?? 0.0).toStringAsFixed(0)}"),
            ],
            if (pd.discount != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_offer, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${pd.discount!.value} OFF - ${pd.discount!.description}",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _selectionSection(String title, IconData icon, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.darkBlue),
            const SizedBox(width: 8),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _serviceChips() => Wrap(
        spacing: 8,
        children: widget.packageDetail.serviceType.map((s) {
          final sel = selectedServiceTypes.contains(s);
          return ChoiceChip(
            label: Text("${s.name} (+\$${s.serviceCost!.toStringAsFixed(2)})"),
            selected: sel,
            onSelected: (_) {
              setState(() {
                sel
                    ? selectedServiceTypes.remove(s)
                    : selectedServiceTypes.add(s);
                _calculateTotalPrice();
              });
            },
          );
        }).toList(),
      );

  Widget _occasionChips() => Wrap(
        spacing: 8,
        children: widget.packageDetail.occasionTypes.map((o) {
          final sel = selectedOccasionTypes.contains(o);
          return ChoiceChip(
            label: Text(o.name),
            selected: sel,
            onSelected: (_) {
              setState(() {
                sel
                    ? selectedOccasionTypes.clear()
                    : selectedOccasionTypes = [o];
                _calculateTotalPrice();
              });
            },
          );
        }).toList(),
      );

  Widget _sliderSection() => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Extra Persons (${extraPersons}/${widget.packageDetail.maxExtraPersons})"),
              Slider(
                value: extraPersons.toDouble(),
                min: 0,
                max: widget.packageDetail.maxExtraPersons.toDouble(),
                divisions: widget.packageDetail.maxExtraPersons,
                label: "$extraPersons",
                onChanged: (v) => setState(() {
                  extraPersons = v.toInt();
                  _calculateTotalPrice();
                }),
              ),
            ],
          ),
        ),
      );

  Widget _checkboxSection() => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: const Text("Extras"),
          children: widget.packageDetail.extras.map((e) {
            final sel = selectedExtras.any((x) => x.id == e.id);
            return CheckboxListTile(
              value: sel,
              onChanged: (v) => setState(() {
                if (v == true)
                  selectedExtras.add(e);
                else
                  selectedExtras.removeWhere((x) => x.id == e.id);
                _calculateTotalPrice();
              }),
              title: Text(e.name),
              subtitle: Text("\$${e.price!.toStringAsFixed(2)}"),
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        ),
      );

  Widget _itemsSection() => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ...widget.packageDetail.items.map((i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(i.foodItemName),
                    trailing: Chip(
                      label: Text(i.isOptional ? "Optional" : "Required"),
                      backgroundColor: i.isOptional
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                    ),
                  )),
            ],
          ),
        ),
      );

  Widget _totalAndButton() => Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.darkBlue.withOpacity(0.2),
                  AppTheme.darkBlue.withOpacity(0.1)
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("\$${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isOrderValid ? _confirmOrder : null,
              child: const Text("Add to cart", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      );
}
