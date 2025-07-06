import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MyOrder extends StatefulWidget {
  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  int _currentIndex = 1;

  final List<String> notifications = [

  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        // centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(notifications[index]),
          );
        },
      ),
      bottomNavigationBar: SalomonBottomBar(
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
      ),
    );
  }
}
