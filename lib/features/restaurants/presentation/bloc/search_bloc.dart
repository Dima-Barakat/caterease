import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:caterease/features/restaurants/domain/entities/restaurant.dart';
import 'package:caterease/features/restaurants/data/services/search_service.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart'; // Import LocationBloc

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Restaurant> allRestaurants;
  final SearchService _searchService = SearchService();
  final LocationBloc _locationBloc; // Add LocationBloc dependency
  Timer? _debounceTimer;
  SearchFilter? _currentFilter;

  static const Duration _debounceDuration = Duration(milliseconds: 300);

  SearchBloc(
      {required this.allRestaurants,
      required LocationBloc locationBloc}) // Update constructor
      : _locationBloc = locationBloc,
        super(SearchInitial()) {
    on<PerformSearchEvent>(_onPerformSearchEvent);
    on<ClearSearchEvent>(_onClearSearchEvent);
    on<UpdateSearchQueryEvent>(_onUpdateSearchQueryEvent);
    on<ApplyFilterEvent>(_onApplyFilterEvent);
    on<ClearFilterEvent>(_onClearFilterEvent);
  }

  void _onUpdateSearchQueryEvent(
      UpdateSearchQueryEvent event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();

    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Show loading immediately for better UX
    emit(SearchLoading());

    _debounceTimer = Timer(_debounceDuration, () {
      add(PerformSearchEvent(query: event.query, filter: _currentFilter));
    });
  }

  void _onPerformSearchEvent(
      PerformSearchEvent event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Determine if location permission is granted
    final bool hasLocationPermission =
        _locationBloc.state is LocationLoaded; // Check LocationBloc state

    try {
      // Use SearchService for filtering
      final filteredRestaurants = _searchService.searchRestaurants(
        event.query,
        allRestaurants,
        filter: event.filter,
        hasLocationPermission: hasLocationPermission, // Pass the new parameter
      );

      if (filteredRestaurants.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(results: filteredRestaurants));
      }
    } catch (e) {
      emit(SearchError(message: 'حدث خطأ أثناء البحث: ${e.toString()}'));
    }
  }

  void _onApplyFilterEvent(ApplyFilterEvent event, Emitter<SearchState> emit) {
    _currentFilter = event.filter;

    // Re-perform search with new filter if there's an active query
    final currentState = state;
    if (currentState is SearchLoaded) {
      // Get the last search query from the current results
      // For simplicity, we'll trigger a new search
      emit(SearchLoading());
      add(PerformSearchEvent(
          query: event.lastQuery ?? '', filter: _currentFilter));
    }
  }

  void _onClearFilterEvent(ClearFilterEvent event, Emitter<SearchState> emit) {
    _currentFilter = null;

    // Re-perform search without filter if there's an active query
    final currentState = state;
    if (currentState is SearchLoaded) {
      emit(SearchLoading());
      add(PerformSearchEvent(query: event.lastQuery ?? '', filter: null));
    }
  }

  void _onClearSearchEvent(ClearSearchEvent event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    _currentFilter = null;
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
