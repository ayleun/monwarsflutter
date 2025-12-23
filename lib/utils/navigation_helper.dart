import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateFromBottomNav(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        break;
      case 1:
        Navigator.pushNamed(context, '/juzz-list');
        break;
      case 2:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  static int getCurrentIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case '/':
        return 0;
      case '/juzz-list':
        return 1;
      case '/favorites':
        return 2;
      case '/settings':
        return 3;
      case '/prayer-times':
      case '/qibla':
      case '/tasbih':
        return -1; // Show navbar but no selection for these pages
      default:
        return -1; // No selection for other pages (like reading)
    }
  }
  
  static bool shouldShowNavbar(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    // Don't show navbar on reading page
    return route != '/reading';
  }
}

