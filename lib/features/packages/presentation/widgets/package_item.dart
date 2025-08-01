import 'dart:convert';
import 'package:caterease/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:caterease/features/packages/domain/entities/package.dart';

class PackageItem extends StatelessWidget {
  final Package package;
  final VoidCallback? onTap;

  const PackageItem({
    Key? key,
    required this.package,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // -------------------
    // 1) بناء صورة من Base64
    // -------------------
    Widget _buildImage() {
      final raw = package.photo; // من entity: String
      if (raw.isNotEmpty && raw.toLowerCase() != 'null') {
        // إذا في بادئة data URI
        var str = raw.contains(',') ? raw.split(',')[1] : raw;
        // نظّف أي مسافات أو علامات اقتباس
        str =
            str.replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'["\\]'), '');
        // ضمّ padding لو ناقص
        final mod4 = str.length % 4;
        if (mod4 > 0) str += '=' * (4 - mod4);

        try {
          final bytes = base64Decode(str);
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              bytes,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        } catch (_) {
          // فشل الفك => placeholder
        }
      }
      // لا صورة => placeholder
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.photo,
          size: 64,
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      );
    }

    // -------------------
    // 2) عرض الكارد مع الصورة والتاج
    // -------------------
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.pushNamed(
            context,
            '/packageDetails',
            arguments: package,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _buildImage(),
                  // تاج السعر
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${package.basePrice}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      package.description,
                      style: Theme.of(context).textTheme.bodyLarge,
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
                          '${package.servesCount} serves',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: onTap ?? () {
                            Navigator.pushNamed(
                              context,
                              '/packageDetails',
                              arguments: package,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightGreen,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('View'),
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
