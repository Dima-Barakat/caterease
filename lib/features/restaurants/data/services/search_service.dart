import 'dart:async';
import 'package:caterease/features/restaurants/domain/entities/restaurant.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final Map<String, SearchCacheEntry> _cache = {};
  final Map<String, List<String>> _searchHistory = {};
  Timer? _cacheCleanupTimer;
  
  static const int maxCacheSize = 100;
  static const Duration cacheExpiration = Duration(minutes: 10);
  static const int maxHistorySize = 50;

  void initialize() {
    _startCacheCleanup();
  }

  void dispose() {
    _cacheCleanupTimer?.cancel();
    _cache.clear();
    _searchHistory.clear();
  }

  void _startCacheCleanup() {
    _cacheCleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _cleanupExpiredCache(),
    );
  }

  void _cleanupExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = _cache.entries
        .where((entry) => now.difference(entry.value.timestamp) > cacheExpiration)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }

  List<Restaurant> searchRestaurants(
    String query,
    List<Restaurant> allRestaurants, {
    SearchFilter? filter,
    required bool hasLocationPermission, // New parameter
  }) {
    if (query.isEmpty) return [];

    final normalizedQuery = query.toLowerCase().trim();
    final cacheKey = _generateCacheKey(normalizedQuery, filter, hasLocationPermission);

    // Check cache first
    final cachedEntry = _cache[cacheKey];
    if (cachedEntry != null && !_isCacheExpired(cachedEntry)) {
      return cachedEntry.results;
    }

    // Perform search
    final results = _performSearch(normalizedQuery, allRestaurants, filter, hasLocationPermission);

    // Cache results
    _cacheResults(cacheKey, results);

    // Add to search history
    _addToSearchHistory(normalizedQuery);

    return results;
  }

  List<Restaurant> _performSearch(
    String query,
    List<Restaurant> allRestaurants,
    SearchFilter? filter,
    bool hasLocationPermission, // New parameter
  ) {
    final queryWords = query.split(' ').where((word) => word.isNotEmpty).toList();
    
    var filteredRestaurants = allRestaurants.where((restaurant) {
      final restaurantName = restaurant.name.toLowerCase();
      final restaurantDescription = restaurant.description.toLowerCase();
      final cityName = restaurant.city?.name.toLowerCase() ?? '';

      // Multi-field search with word matching
      final matchesQuery = queryWords.every((word) =>
        restaurantName.contains(word) ||
        restaurantDescription.contains(word) ||
        cityName.contains(word)
      );

      if (!matchesQuery) return false;

      // Apply filters
      if (filter != null) {
        if (filter.minRating != null && restaurant.rating < filter.minRating!) {
          return false;
        }
        if (filter.maxDistance != null && 
            restaurant.distance != null && 
            restaurant.distance! > filter.maxDistance!) {
          return false;
        }
        if (filter.cityId != null && restaurant.city?.id != filter.cityId) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort by relevance and rating/distance
    filteredRestaurants.sort((a, b) {
      // Primary sort: exact name matches first
      final aExactMatch = a.name.toLowerCase().contains(query);
      final bExactMatch = b.name.toLowerCase().contains(query);
      
      if (aExactMatch && !bExactMatch) return -1;
      if (!aExactMatch && bExactMatch) return 1;

      // Secondary sort: name starts with query
      final aStartsWith = a.name.toLowerCase().startsWith(query);
      final bStartsWith = b.name.toLowerCase().startsWith(query);
      
      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;

      // Tertiary sort: based on location permission
      if (hasLocationPermission) {
        // Sort by distance if location permission is granted
        if (a.distance != null && b.distance != null) {
          return a.distance!.compareTo(b.distance!); // Ascending distance (closest first)
        } else if (a.distance != null) {
          return -1; // a has distance, b doesn't - a comes first
        } else if (b.distance != null) {
          return 1; // b has distance, a doesn't - b comes first
        }
      } else {
        // Sort by rating (descending) if no location permission
        final ratingComparison = b.rating.compareTo(a.rating);
        if (ratingComparison != 0) return ratingComparison;
      }

      return 0;
    });

    return filteredRestaurants;
  }

  String _generateCacheKey(String query, SearchFilter? filter, bool hasLocationPermission) {
    final filterKey = filter?.toKey() ?? '';
    return '$query|$filterKey|$hasLocationPermission';
  }

  bool _isCacheExpired(SearchCacheEntry entry) {
    return DateTime.now().difference(entry.timestamp) > cacheExpiration;
  }

  void _cacheResults(String key, List<Restaurant> results) {
    // Limit cache size
    if (_cache.length >= maxCacheSize) {
      final oldestKey = _cache.entries
          .reduce((a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
          .key;
      _cache.remove(oldestKey);
    }

    _cache[key] = SearchCacheEntry(
      results: results,
      timestamp: DateTime.now(),
    );
  }

  void _addToSearchHistory(String query) {
    final userId = 'default'; // Replace with actual user ID
    
    if (!_searchHistory.containsKey(userId)) {
      _searchHistory[userId] = [];
    }

    final userHistory = _searchHistory[userId]!;
    
    // Remove if already exists
    userHistory.remove(query);
    
    // Add to beginning
    userHistory.insert(0, query);
    
    // Limit history size
    if (userHistory.length > maxHistorySize) {
      userHistory.removeRange(maxHistorySize, userHistory.length);
    }
  }

  List<String> getSearchHistory([String? userId]) {
    userId ??= 'default';
    return _searchHistory[userId] ?? [];
  }

  List<String> getSearchSuggestions(String query, List<Restaurant> allRestaurants) {
    if (query.isEmpty) return getSearchHistory();

    final suggestions = <String>{};
    final normalizedQuery = query.toLowerCase();

    // Add restaurant names that match
    for (final restaurant in allRestaurants) {
      final name = restaurant.name.toLowerCase();
      if (name.contains(normalizedQuery) && name != normalizedQuery) {
        suggestions.add(restaurant.name);
      }
    }

    // Add from search history
    final history = getSearchHistory();
    for (final historyItem in history) {
      if (historyItem.toLowerCase().contains(normalizedQuery) && 
          historyItem.toLowerCase() != normalizedQuery) {
        suggestions.add(historyItem);
      }
    }

    return suggestions.take(10).toList();
  }

  void clearCache() {
    _cache.clear();
  }

  void clearSearchHistory([String? userId]) {
    userId ??= 'default';
    _searchHistory[userId]?.clear();
  }
}

class SearchCacheEntry {
  final List<Restaurant> results;
  final DateTime timestamp;

  SearchCacheEntry({
    required this.results,
    required this.timestamp,
  });
}

class SearchFilter {
  final double? minRating;
  final double? maxDistance;
  final int? cityId;

  const SearchFilter({
    this.minRating,
    this.maxDistance,
    this.cityId,
  });

  String toKey() {
    return '${minRating ?? 'null'}_${maxDistance ?? 'null'}_${cityId ?? 'null'}';
  }
}

