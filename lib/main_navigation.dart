import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/cart/presentation/pages/cart_page.dart';
import 'package:caterease/features/profile/presentation/screens/profile/profile_view_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:caterease/features/restaurants/presentation/pages/home_page.dart';
import 'package:caterease/features/packages/presentation/pages/packages_main_page.dart';
import 'package:caterease/features/delivery/presentation/screens/orders_main_page.dart';
import 'package:caterease/features/customer_order_list/presentation/pages/customer_order_list_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    HomePage(),
    CustomerOrderListScreen(), // New screen added here
    OrdersMainPage(),
    CartPage(),
    ProfileViewPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.list_alt, size: 30, color: Colors.white), // New icon for customer order list
          Icon(Icons.local_offer, size: 30, color: Colors.white),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: AppTheme.darkBlue,
        buttonBackgroundColor: AppTheme.lightGreen,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _pages[_page],
    );
  }

  void setPage(int index) {
    final CurvedNavigationBarState? navBarState =
        _bottomNavigationKey.currentState;
    navBarState?.setPage(index);
  }
}


