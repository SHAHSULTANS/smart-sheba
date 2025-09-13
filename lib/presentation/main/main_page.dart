import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  final Widget child;
  
  const MainPage({
    super.key,
    required this.child,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      route: '/',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'হোম',
    ),
    NavigationItem(
      route: '/services',
      icon: Icons.build_outlined,
      activeIcon: Icons.build,
      label: 'সেবাসমূহ',
    ),
    NavigationItem(
      route: '/bookings',
      icon: Icons.bookmark_border_outlined,
      activeIcon: Icons.bookmark,
      label: 'বুকিং',
    ),
    NavigationItem(
      route: '/profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'প্রোফাইল',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Get current route to determine active tab
    final String location = GoRouterState.of(context).uri.toString();
    _currentIndex = _navigationItems.indexWhere(
      (item) => item.route == location,
    );
    if (_currentIndex == -1) _currentIndex = 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            context.go(_navigationItems[index].route);
          }
        },
        type: BottomNavigationBarType.fixed,
        items: _navigationItems.map((item) {
          final isActive = _navigationItems.indexOf(item) == _currentIndex;
          return BottomNavigationBarItem(
            icon: Icon(isActive ? item.activeIcon : item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
