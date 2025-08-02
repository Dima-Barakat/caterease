import 'package:caterease/features/packages/presentation/pages/packages_page.dart';
import 'package:caterease/features/restaurants/presentation/widgets/base64_image_widget.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final String defaultImagePath = 'assets/images/restaurant_placeholder.png';

  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: SizedBox(
        width: 250,
        height: null, // ارتفاع ديناميكي
        child: Container(
          key: Key('restaurant_card_${restaurant.id}'),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
              // صورة المطعم مع صورة افتراضية في حالة null
              Base64ImageWidget(
                base64String: restaurant.photo ?? '',
                height: 180,
                width: double.infinity,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المطعم
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl, // للنصوص العربية
                    ),
                    const SizedBox(height: 6),
                    // وصف المطعم
                    Text(
                      restaurant.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl, // للنصوص العربية
                    ),
                    const SizedBox(height: 8),
                    // تقييم المطعم والمسافة
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
