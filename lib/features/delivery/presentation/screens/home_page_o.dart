import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/delivery/presentation/screens/my_order.dart';
import 'package:caterease/features/profile/presentation/screens/profile/setting_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomePageO extends StatefulWidget {
  const HomePageO({super.key});

  @override
  State<HomePageO> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageO> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MyOrder(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ConvexAppBar(
        color: AppTheme.lightGray,
        backgroundColor: AppTheme.darkBlue,
        activeColor: AppTheme.lightGreen,
        initialActiveIndex: _currentIndex,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          // TabItem(icon: Icons.receipt_long, title: 'Orders'),
          TabItem(icon: Icons.settings, title: 'Settings'),
        ],
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
    /*
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: AppTheme.darkBlue,
        buttonBackgroundColor: AppTheme.lightGreen,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
        // letIndexChange: (index) => true,
      ),  */
  }
}
