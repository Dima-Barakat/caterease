import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/restaurants/presentation/pages/category_restaurants_page.dart';
import 'package:caterease/features/restaurants/presentation/pages/search_results_page_fixed.dart';
import 'package:caterease/features/restaurants/presentation/widgets/enhanced_search_bar.dart';
import 'package:caterease/features/restaurants/presentation/widgets/city_filter_widget.dart'; // الجديد
import 'package:caterease/features/restaurants/presentation/bloc/search_bloc.dart';
import 'package:caterease/features/restaurants/data/services/search_service.dart';
import 'package:caterease/features/restaurants/domain/entities/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/restaurants/presentation/bloc/restaurants_bloc.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart';
import 'package:caterease/features/restaurants/presentation/widgets/restaurant_card.dart';
import 'package:caterease/features/location/presentation/widgets/location_permission_widget.dart';
import 'package:caterease/main.dart';
import 'package:caterease/injection_container.dart' as di;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final categories = [
    {"name": "Western", "image": "assets/images/westren.jpg"},
    {"name": "Eastern", "image": "assets/images/eastren.jpg"},
    {"name": "Desserts", "image": "assets/images/sweets.jpg"},
    {"name": "Soft Drinks", "image": "assets/images/drinks.jpg"},
  ];

  bool _showSearchResults = false;
  SearchBloc? _searchBloc;

  // الجديد - متغيرات للفلترة حسب المحافظة
  int? _selectedCityId;
  bool _showCityFilter = false;

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(RequestLocationPermissionEvent());
    SearchService().initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchBloc?.close();
    SearchService().dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    final locationState = context.read<LocationBloc>().state;

    if (locationState is LocationLoaded) {
      context.read<RestaurantsBloc>().add(
            LoadNearbyRestaurantsEvent(
              latitude: locationState.position.latitude,
              longitude: locationState.position.longitude,
            ),
          );
    } else {
      context.read<LocationBloc>().add(GetCurrentLocationEvent());
    }
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                di.sl.get<SearchBloc>(param1: _getCurrentRestaurants()),
            child: SearchResultsPage(
              initialQuery: query,
              allRestaurants: _getCurrentRestaurants(),
            ),
          ),
        ),
      );
    }
  }

  void _toggleSearchResults() {
    setState(() {
      _showSearchResults = !_showSearchResults;
    });
  }

  // الجديد - methods للفلترة حسب المحافظة
  void _toggleCityFilter() {
    setState(() {
      _showCityFilter = !_showCityFilter;
    });
  }

  void _onCitySelected(int cityId) {
    setState(() {
      _selectedCityId = cityId == 0 ? null : cityId; // 0 يعني جميع المحافظات
      _showCityFilter = false;
    });

    if (cityId == 0) {
      // جميع المطاعم
      context.read<RestaurantsBloc>().add(LoadAllRestaurantsEvent());
    } else {
      // مطاعم محافظة معينة
      context.read<RestaurantsBloc>().add(
            LoadRestaurantsByCityEvent(cityId: cityId),
          );
    }
  }

  String _getSelectedCityName() {
    if (_selectedCityId == null) return 'جميع المحافظات';

    final city = CityFilterWidget.syrianCities.firstWhere(
      (c) => c['id'] == _selectedCityId,
      orElse: () => {'name': 'غير محدد'},
    );
    return city['name'];
  }

  List<Restaurant> _getCurrentRestaurants() {
    final restaurantsState = context.read<RestaurantsBloc>().state;
    if (restaurantsState is RestaurantsLoaded) {
      return restaurantsState.restaurants;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('CaterEase'),
        centerTitle: true,
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, locationState) {
          if (locationState is LocationPermissionGranted) {
            context.read<LocationBloc>().add(GetCurrentLocationEvent());
          } else if (locationState is LocationLoaded) {
            context.read<LocationBloc>().add(
                  SendLocationToServerEvent(
                    locationState.position.latitude,
                    locationState.position.longitude,
                  ),
                );

            context.read<RestaurantsBloc>().add(
                  LoadNearbyRestaurantsEvent(
                    latitude: locationState.position.latitude,
                    longitude: locationState.position.longitude,
                  ),
                );
          } else if (locationState is LocationError) {
            context.read<RestaurantsBloc>().add(LoadAllRestaurantsEvent());
          }
        },
        builder: (context, locationState) {
          if (locationState is LocationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (locationState is LocationError) {
            // الجديد - عرض واجهة الفلترة عند رفض إذن الموقع
            return Column(
              children: [
                // شريط الفلترة
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            print("Toggle City Filter pressed");
                            _toggleCityFilter();
                          },
                          icon: const Icon(Icons.filter_list,
                              color: AppTheme.darkBlue),
                          label: Text(
                            _selectedCityId != null
                                ? 'المحافظة: ${_getSelectedCityName()}'
                                : 'اختر المحافظة',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.fontBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightBlue,
                            foregroundColor: AppTheme.fontBlack,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          print("Reset to all cities");
                          setState(() {
                            _selectedCityId = null;
                            _showCityFilter = false;
                          });
                          context
                              .read<RestaurantsBloc>()
                              .add(LoadAllRestaurantsEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.darkBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'الكل',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // عرض فلتر المحافظات
                if (_showCityFilter)
                  Container(
                    margin: EdgeInsets.all(16),
                    child: CityFilterWidget(
                      onCitySelected: _onCitySelected,
                      selectedCityId: _selectedCityId,
                    ),
                  ),

                // باقي المحتوى
                Expanded(
                  child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
                    builder: (context, restaurantsState) {
                      if (restaurantsState is RestaurantsLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (restaurantsState is RestaurantsLoaded) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Bar
                              BlocProvider(
                                create: (context) => di.sl.get<SearchBloc>(
                                    param1: restaurantsState.restaurants),
                                child: EnhancedSearchBar(
                                  onSearchChanged: _onSearchChanged,
                                  hintText: 'ابحث عن المطاعم...',
                                  showResults: _showSearchResults,
                                  onResultsToggle: _toggleSearchResults,
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  _selectedCityId != null
                                      ? "مطاعم ${_getSelectedCityName()}"
                                      : "جميع المطاعم",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 330,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount:
                                      restaurantsState.restaurants.length,
                                  itemBuilder: (context, index) {
                                    return RestaurantCard(
                                      restaurant:
                                          restaurantsState.restaurants[index],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                                child: Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  itemBuilder: (context, index) {
                                    final cat = categories[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryRestaurantsPage(
                                                    category: cat["name"]!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 17),
                                        width: 120,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      AssetImage(cat["image"]!),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 6,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              cat["name"]!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        );
                      } else if (restaurantsState is RestaurantsError) {
                        return Center(child: Text(restaurantsState.message));
                      } else {
                        return Center(child: Text('لا توجد مطاعم لعرضها.'));
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            // الحالة العادية عندما يكون هناك إذن موقع
            return BlocBuilder<RestaurantsBloc, RestaurantsState>(
              builder: (context, restaurantsState) {
                if (restaurantsState is RestaurantsLoading) {
                  print(">> THE STATE IS: $restaurantsState");

                  return Center(child: CircularProgressIndicator());
                } else if (restaurantsState is RestaurantsLoaded) {
                  print(">> THE STATE IS: $restaurantsState");

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        BlocProvider(
                          create: (context) => di.sl.get<SearchBloc>(
                              param1: restaurantsState.restaurants),
                          child: EnhancedSearchBar(
                            onSearchChanged: _onSearchChanged,
                            hintText: 'ابحث عن المطاعم...',
                            showResults: _showSearchResults,
                            onResultsToggle: _toggleSearchResults,
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "المطاعم القريبة",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 330,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: restaurantsState.restaurants.length,
                            itemBuilder: (context, index) {
                              return RestaurantCard(
                                restaurant: restaurantsState.restaurants[index],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          child: Text(
                            "Categories",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryRestaurantsPage(
                                              category: cat["name"]!),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 17),
                                  width: 120,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(cat["image"]!),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        cat["name"]!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  );
                } else if (restaurantsState is RestaurantsError) {
                  print(">> THE STATE IS: $restaurantsState");
                  return Center(
                      child: Text(
                          "${restaurantsState.message}/n >> THE STATE IS: $restaurantsState"));
                } else {
                  print(">> THE STATE IS: $restaurantsState");
                  return Center(child: Text('لا توجد مطاعم لعرضها.'));
                }
              },
            );
          }
        },
      ),
    );
  }
}
