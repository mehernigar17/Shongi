import 'package:flutter/material.dart';
import 'package:shongi/features/profile/views/profile_view.dart';
import 'package:shongi/features/statistics/views/statistics_view.dart';
import 'package:shongi/app/floating_nav_bar.dart';
import '../features/dashboard/views/dashboard_view.dart';
import '../features/health/views/health_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    StatisticsScreen(),
    //DoctorsScreen(),
    HealthScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
      
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
