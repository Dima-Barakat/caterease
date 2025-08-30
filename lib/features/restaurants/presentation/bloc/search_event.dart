part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class UpdateSearchQueryEvent extends SearchEvent {
  final String query;

  const UpdateSearchQueryEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class PerformSearchEvent extends SearchEvent {
  final String query;
  final SearchFilter? filter;

  const PerformSearchEvent({required this.query, this.filter});

  @override
  List<Object?> get props => [query, filter];
}

class ApplyFilterEvent extends SearchEvent {
  final SearchFilter filter;
  final String? lastQuery;

  const ApplyFilterEvent({required this.filter, this.lastQuery});

  @override
  List<Object?> get props => [filter, lastQuery];
}

class ClearFilterEvent extends SearchEvent {
  final String? lastQuery;

  const ClearFilterEvent({this.lastQuery});

  @override
  List<Object?> get props => [lastQuery];
}

class ClearSearchEvent extends SearchEvent {}

