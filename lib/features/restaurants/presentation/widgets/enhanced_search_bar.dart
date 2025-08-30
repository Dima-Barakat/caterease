import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/restaurants/presentation/bloc/search_bloc.dart';
import 'package:caterease/features/restaurants/presentation/widgets/restaurant_card.dart';

class EnhancedSearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final String? hintText;
  final bool showResults;
  final VoidCallback? onResultsToggle;

  const EnhancedSearchBar({
    Key? key,
    this.onSearchChanged,
    this.hintText,
    this.showResults = false,
    this.onResultsToggle,
  }) : super(key: key);

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_isExpanded) {
        _expandSearch();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _expandSearch() {
    setState(() {
      _isExpanded = true;
    });
    _animationController.forward();
    widget.onResultsToggle?.call();
  }

  void _collapseSearch() {
    setState(() {
      _isExpanded = false;
    });
    _animationController.reverse();
    _controller.clear();
    _focusNode.unfocus();
    context.read<SearchBloc>().add(ClearSearchEvent());
    widget.onResultsToggle?.call();
  }

  void _onSearchChanged(String query) {
    context.read<SearchBloc>().add(UpdateSearchQueryEvent(query: query));
    widget.onSearchChanged?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      children: [
        // Search Bar Container
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search Icon
              Padding(
                padding: EdgeInsets.only(
                  left: isRTL ? 8 : 16,
                  right: isRTL ? 16 : 8,
                ),
                child: Icon(
                  Icons.search,
                  color: theme.primaryColor,
                  size: 24,
                ),
              ),
              // Search TextField
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? 'ابحث عن المطاعم...',
                    hintStyle: TextStyle(
                      color: theme.hintColor,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              // Loading Indicator or Clear Button
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  } else if (_controller.text.isNotEmpty) {
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        _onSearchChanged('');
                      },
                      color: theme.hintColor,
                    );
                  }
                  return const SizedBox(width: 16);
                },
              ),
              // Close Button (when expanded)
              if (_isExpanded)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _collapseSearch,
                  color: theme.hintColor,
                ),
            ],
          ),
        ),
        // Search Results
        if (widget.showResults)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildSearchResults(),
          ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const SizedBox.shrink();
        } else if (state is SearchLoading) {
          return Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is SearchEmpty) {
          return Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد نتائج للبحث',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'جرب البحث بكلمات مختلفة',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is SearchLoaded) {
          return Container(
            constraints: const BoxConstraints(maxHeight: 400),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Results Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'نتائج البحث',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${state.results.length} مطعم',
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
                // Results List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RestaurantCard(
                          restaurant: state.results[index],
                          isCompact: true,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        } else if (state is SearchError) {
          return Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في البحث',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
