import 'package:caterease/core/theming/colors_theme.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
//import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MyOrder extends StatefulWidget {
  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  // int _currentIndex = 1;

  final List<String> notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        // centerTitle: true,
      ),
      body: Card(
          color: ColorsTheme.lightBlue,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("aaaa")],
            ),
          )),
      bottomNavigationBar: ConvexAppBar(
        color: ColorsTheme.lightGray,
        backgroundColor: ColorsTheme.darkBlue,
        activeColor: ColorsTheme.lightGreen,
        initialActiveIndex: 0,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.settings, title: 'setting'),
        ],
        onTap: (int i) => print('click index=$i'),
      ),
      /*  bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          SalomonBottomBarItem(
              icon: Icon(Icons.settings),
              title: Text("settings"),
              unselectedColor: Color(0xFFB7D6B7),
              selectedColor: Color(0xFF314E76)),
          SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              unselectedColor: Color(0xFFB7D6B7),
              selectedColor: Color(0xFF314E76)),
          SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("profile"),
              unselectedColor: Color(0xFFB7D6B7),
              selectedColor: Color(0xFF314E76)),
        ],
      ), */
    );
  }
}
