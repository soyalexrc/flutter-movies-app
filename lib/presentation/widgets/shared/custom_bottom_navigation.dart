import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    switch (location) {
      case '/':
        return 0;
        break;
      case '/categories':
        return 1;
        break;
      case '/favorites':
        return 2;
        break;
      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/');
        break;
      case 2:
        context.go('/favorites');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      elevation: 0,
        currentIndex: getCurrentIndex(context),
        onTap: (value) => onItemTapped(context, value),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_max),
            label: 'Movies'
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.label_outline),
            label: 'Categories'
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
            label: 'Favorites'
          )
        ]
    );
  }
}
