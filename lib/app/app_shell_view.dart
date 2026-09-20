import 'package:flutter/material.dart';
import 'package:shongi/features/profile/views/profile_view.dart';
import 'package:shongi/features/statistics/views/statistics_view.dart';
import 'package:shongi/app/floating_nav_bar.dart';
import 'package:shongi/app/app_dependencies.dart';
import '../features/dashboard/views/dashboard_view.dart';
import '../features/health/views/health_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.dependencies});
  final AppDependencies? dependencies;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<StatisticsScreenState> _statsKey = GlobalKey<StatisticsScreenState>();
  final GlobalKey<ProfileScreenState> _profileKey = GlobalKey<ProfileScreenState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final deps = widget.dependencies;
    _pages = [
      HomeScreen(key: _homeKey, dependencies: deps),
      StatisticsScreen(key: _statsKey, dependencies: deps),
      HealthScreen(dependencies: deps),
      ProfileScreen(key: _profileKey, dependencies: deps),
    ];
  }

  void _onItemSelected(int index) {
    setState(() => _selectedIndex = index);
    // Refresh each screen with fresh Firestore data whenever the user
    // navigates back to it (e.g. after logging a period or a daily log).
    switch (index) {
      case 0:
        _homeKey.currentState?.reload();
      case 1:
        _statsKey.currentState?.reload();
      case 3:
        _profileKey.currentState?.reload();
    }
  }

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
              onItemSelected: _onItemSelected,
            ),
          ),
        ],
      ),
    );
  }
}