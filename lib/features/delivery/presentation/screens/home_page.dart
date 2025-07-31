import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/delivery/presentation/screens/my_order.dart';
import 'package:caterease/features/delivery/presentation/screens/order_details.dart';
import 'package:caterease/features/profile/presentation/screens/profile/setting_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomePageO extends StatefulWidget {
  @override
  State<HomePageO> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageO> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MyOrder(),
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
  }
}
