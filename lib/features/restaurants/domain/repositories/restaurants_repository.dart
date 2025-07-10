import "dart:convert";

import "package:caterease/features/restaurants/data/models/branch_model.dart";
import "package:dartz/dartz.dart";
import "package:http/http.dart" as http;
import "../../../../core/error/failures.dart";
import "../entities/restaurant.dart";

abstract class RestaurantsRepository {
  Future<List<BranchModel>> getBranchesByCategory(String category);

  Future<Either<Failure, List<Restaurant>>> getNearbyRestaurants(
    double latitude,
    double longitude,
  );

  Future<Either<Failure, List<Restaurant>>> getAllRestaurants();
}

Future<List<BranchModel>> getRestaurantsByCategory(String category) async {
  print("📥 [START] getRestaurantsByCategory called with category: $category");

  final url =
      Uri.parse('http://192.168.0.106:8000/api/branches/category/$category');
  print("🌐 API URL: $url");

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer 2|wXnBBvtboZdhN2rcWPGXcxCwDL0hqAZ034kjOhPW45936c9d',
        'Accept': 'application/json',
      },
    );

    print("📡 Response Status Code: ${response.statusCode}");
    print("📝 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print("✅ JSON Decoded Successfully");

      final data = decoded['data'] as List<dynamic>;
      print("📦 Extracted Data Length: ${data.length}");

      final branches = data.map((item) {
        print("➡️ Parsing item: $item");
        return BranchModel.fromJson(item);
      }).toList();

      print("🎯 Parsed ${branches.length} branches successfully");
      return branches;
    } else {
      print("❌ API Error: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception("Failed to fetch restaurants");
    }
  } catch (e, stack) {
    print("💥 Exception occurred: $e");
    print("📍 StackTrace: $stack");
    throw Exception("Failed to fetch restaurants : $e");
  }
}
