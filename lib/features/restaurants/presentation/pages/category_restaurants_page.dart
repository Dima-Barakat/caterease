import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/restaurants/domain/entities/restaurant.dart';
import 'package:caterease/features/restaurants/presentation/bloc/restaurants_bloc.dart';
import 'package:caterease/features/restaurants/presentation/widgets/restaurant_card.dart';
import '../../../../main.dart'; // ضروري لـ routeObserver

class CategoryRestaurantsPage extends StatefulWidget {
  final String category;

  const CategoryRestaurantsPage({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryRestaurantsPage> createState() =>
      _CategoryRestaurantsPageState();
}

class _CategoryRestaurantsPageState extends State<CategoryRestaurantsPage>
    with RouteAware {
  bool _loadedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route); // ✅ الاشتراك بالمراقبة
    }

    _loadRestaurants();
  }

  void _loadRestaurants() {
    if (!_loadedOnce) {
      context.read<RestaurantsBloc>().add(
            GetRestaurantsByCategoryEvent(widget.category),
          );
      _loadedOnce = true;
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // ما بنعيد تحميل البيانات إذا كانت محملة مسبقًا
    // أو أعد تحميلها إذا بدك تحدث الصفحة عند الرجوع
    // context.read<RestaurantsBloc>().add(GetRestaurantsByCategoryEvent(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Restaurants'),
        centerTitle: true,
      ),
      body: BlocBuilder<RestaurantsBloc, RestaurantsState>(
        builder: (context, state) {
          if (state is RestaurantsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestaurantsByCategoryLoaded) {
            final branches = state.restaurants;

            if (branches.isEmpty) {
              return const Center(child: Text('No restaurants found.'));
            }

            return ListView.builder(
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                return RestaurantCard(
                  restaurant: Restaurant(
                    id: branch.branchId,
                    name: '${branch.restaurant} - ${widget.category}',
                    description: branch.description,
                    photo: branch.imageUrl ?? '', // ✅ لتفادي null
                    rating: 4.5,
                    totalRatings: 200,
                    distance: branch.distanceKm,
                    city: null,
                  ),
                );
              },
            );
          } else if (state is RestaurantsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
