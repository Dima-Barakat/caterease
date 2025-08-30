import 'package:caterease/features/packages/presentation/pages/packages_page.dart';
import 'package:caterease/features/restaurants/presentation/widgets/base64_image_widget.dart';
import 'package:caterease/features/restaurants/presentation/widgets/branch_feedback_popup.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/restaurant.dart';

class BranchCard extends StatelessWidget {
  final Restaurant restaurant;
  final String defaultImagePath = 'assets/images/restaurant_placeholder.png';
  final bool isCompact;

  const BranchCard({
    Key? key,
    required this.restaurant,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildCompactCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackagesPage(
              branchId: restaurant.id,
              branchName: restaurant.name,
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => BranchFeedbackPopup(
            branchId: restaurant.id,
            branchName: restaurant.name,
          ),
        );
      },
      child: Container(
        key: Key('branch_card_compact_${restaurant.id}'),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Base64ImageWidget(
              base64String: restaurant.photo ?? '',
              height: 90,
              width: 90,
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(14)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (restaurant.distance != null)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[500],
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                "${restaurant.distance!.toStringAsFixed(1)} كم",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildFullCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackagesPage(
              branchId: restaurant.id,
              branchName: restaurant.name,
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => BranchFeedbackPopup(
            branchId: restaurant.id,
            branchName: restaurant.name,
          ),
        );
      },
      child: SizedBox(
        width: 320, // تكبير الكارد
        height: 380, // ارتفاع أكبر للكارد
        child: Container(
          key: Key('branch_card_${restaurant.id}'),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Base64ImageWidget(
                base64String: restaurant.photo ?? '',
                height: 220, // صورة أكبر
                width: double.infinity,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(19), // زيادة padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      restaurant.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " (${restaurant.totalRatings} تقييم)",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        if (restaurant.distance != null)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[500],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${restaurant.distance!.toStringAsFixed(1)} كم",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
