import 'package:caterease/features/restaurants/presentation/pages/category_restaurants_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/restaurants/presentation/bloc/restaurants_bloc.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart';
import 'package:caterease/features/restaurants/presentation/widgets/restaurant_card.dart';
import 'package:caterease/features/location/presentation/widgets/location_permission_widget.dart';
import 'package:caterease/main.dart'; // استيراد routeObserver

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

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(RequestLocationPermissionEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute); // ✅ مهم
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // ✅ مهم
    super.dispose();
  }

  @override
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
            // ⬇️⬇️ إرسال الموقع للسيرفر
            context.read<LocationBloc>().add(
                  SendLocationToServerEvent(
                    locationState.position.latitude,
                    locationState.position.longitude,
                  ),
                );

            // تحميل المطاعم القريبة
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
          } else if (locationState is LocationError &&
              locationState.message == "تم رفض إذن الموقع") {
            return LocationPermissionWidget();
          } else {
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
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "All Restaurants",
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
