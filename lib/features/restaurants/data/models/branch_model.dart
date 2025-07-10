class BranchModel {
  final int branchId;
  final String restaurant;
  final String description;
  final String locationNote;
  final String latitude;
  final String longitude;
  final double distanceKm;
  final List<String> categories;
  final String? imageUrl;

  BranchModel({
    required this.branchId,
    required this.restaurant,
    required this.description,
    required this.locationNote,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.categories,
    required this.imageUrl,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branch_id'],
      restaurant: json['restaurant'],
      description: json['description'],
      locationNote: json['location_note'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distanceKm: (json['distance_km'] as num).toDouble(),
      categories: List<String>.from(json['categories']),
      imageUrl: json['photo'],
    );
  }
}
