import 'package:flutter/material.dart';

class CityFilterWidget extends StatelessWidget {
  final Function(int) onCitySelected;
  final int? selectedCityId;

  const CityFilterWidget({
    Key? key,
    required this.onCitySelected,
    this.selectedCityId,
  }) : super(key: key);

  static const List<Map<String, dynamic>> syrianCities = [
    {'id': 1, 'name': 'دمشق', 'nameEn': 'Damascus'},
    {'id': 2, 'name': 'ريف دمشق', 'nameEn': 'Damascus Countryside'},
    {'id': 3, 'name': 'حلب', 'nameEn': 'Aleppo'},
    {'id': 4, 'name': 'حمص', 'nameEn': 'Homs'},
    {'id': 5, 'name': 'حماة', 'nameEn': 'Hama'},
    {'id': 6, 'name': 'اللاذقية', 'nameEn': 'Latakia'},
    {'id': 7, 'name': 'دير الزور', 'nameEn': 'Deir ez-Zor'},
    {'id': 8, 'name': 'الحسكة', 'nameEn': 'Al-Hasakah'},
    {'id': 9, 'name': 'درعا', 'nameEn': 'Daraa'},
    {'id': 10, 'name': 'السويداء', 'nameEn': 'As-Suwayda'},
    {'id': 11, 'name': 'القنيطرة', 'nameEn': 'Quneitra'},
    {'id': 12, 'name': 'طرطوس', 'nameEn': 'Tartus'},
    {'id': 13, 'name': 'الرقة', 'nameEn': 'Ar-Raqqah'},
    {'id': 14, 'name': 'إدلب', 'nameEn': 'Idlib'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اختر المحافظة',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () {
                  // يمكن إضافة callback لإغلاق الفلتر
                },
                icon: Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200, // تحديد ارتفاع للتمرير
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: syrianCities.map((city) {
                  final isSelected = selectedCityId == city['id'];
                  return GestureDetector(
                    onTap: () => onCitySelected(city['id']),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[600] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Text(
                        city['name'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onCitySelected(0), // 0 يعني جميع المحافظات
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('جميع المحافظات'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

