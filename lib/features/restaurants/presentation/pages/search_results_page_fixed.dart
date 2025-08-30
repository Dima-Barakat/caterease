import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/restaurants/presentation/bloc/search_bloc.dart';
import 'package:caterease/features/restaurants/presentation/widgets/restaurant_card.dart';
import 'package:caterease/features/restaurants/data/services/search_service.dart';
import 'package:caterease/features/restaurants/domain/entities/restaurant.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart'; // Import LocationBloc

class SearchResultsPage extends StatefulWidget {
  final String initialQuery;
  final List<Restaurant> allRestaurants;

  const SearchResultsPage({
    Key? key,
    required this.initialQuery,
    required this.allRestaurants,
  }) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  SearchFilter? _currentFilter;
  bool _showFilters = false;
  late bool _hasLocationPermission; // Track location permission

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    _checkLocationPermission(); // Initial check
    if (widget.initialQuery.isNotEmpty) {
      context.read<SearchBloc>().add(
            PerformSearchEvent(query: widget.initialQuery),
          );
    }
  }

  void _checkLocationPermission() {
    final locationState = context.read<LocationBloc>().state;
    _hasLocationPermission =
        locationState is LocationLoaded; // Update state based on LocationBloc
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<SearchBloc>().add(UpdateSearchQueryEvent(query: query));
  }

  void _applyFilter(SearchFilter filter) {
    setState(() {
      _currentFilter = filter;
      _showFilters = false;
    });

    // Apply filter with current search query
    context.read<SearchBloc>().add(
          ApplyFilterEvent(filter: filter, lastQuery: _searchController.text),
        );
  }

  void _clearFilter() {
    setState(() {
      _currentFilter = null;
    });

    // Clear filter and re-search
    context.read<SearchBloc>().add(
          ClearFilterEvent(lastQuery: _searchController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج البحث'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, locationState) {
          // Listen for changes in location state to update filter options
          setState(() {
            _hasLocationPermission = locationState is LocationLoaded;
          });
        },
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Search TextField
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: isRTL ? 8 : 16,
                              right: isRTL ? 16 : 8,
                            ),
                            child: Icon(
                              Icons.search,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              onChanged: _onSearchChanged,
                              textDirection:
                                  isRTL ? TextDirection.rtl : TextDirection.ltr,
                              decoration: InputDecoration(
                                hintText: 'ابحث عن المطاعم...',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, state) {
                              if (state is SearchLoading) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                );
                              } else if (_searchController.text.isNotEmpty) {
                                return IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                  color: theme.hintColor,
                                );
                              }
                              return const SizedBox(width: 12);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  Container(
                    decoration: BoxDecoration(
                      color: _currentFilter != null
                          ? theme.primaryColor
                          : theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: _currentFilter != null
                            ? Colors.white
                            : theme.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Filter Panel
            if (_showFilters) _buildFilterPanel(),
            // Results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _buildInitialState();
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchEmpty) {
                    return _buildEmptyState();
                  } else if (state is SearchLoaded) {
                    return _buildResultsList(state.results);
                  } else if (state is SearchError) {
                    return _buildErrorState(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'فلترة النتائج',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_currentFilter != null)
                TextButton(
                  onPressed: _clearFilter,
                  child: Text('مسح الفلاتر'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                'تقييم عالي (4+)',
                _currentFilter?.minRating == 4.0,
                () => _applyFilter(SearchFilter(minRating: 4.0)),
              ),
              // Show distance filters only if location permission is granted
              if (_hasLocationPermission)
                _buildFilterChip(
                  'قريب (أقل من 5 كم)',
                  _currentFilter?.maxDistance == 5.0,
                  () => _applyFilter(SearchFilter(maxDistance: 5.0)),
                ),
              if (_hasLocationPermission)
                _buildFilterChip(
                  'قريب جداً (أقل من 2 كم)',
                  _currentFilter?.maxDistance == 2.0,
                  () => _applyFilter(SearchFilter(maxDistance: 2.0)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: 16),
          Text(
            'ابحث عن مطعمك المفضل',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج للبحث',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مختلفة أو قم بتعديل الفلاتر',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(List<Restaurant> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تم العثور على ${results.length} مطعم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              if (_currentFilter != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'مفلتر',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RestaurantCard(
                  restaurant: results[index],
                  isCompact: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في البحث',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
