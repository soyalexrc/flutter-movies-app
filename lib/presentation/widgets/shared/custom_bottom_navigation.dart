import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      elevation: 0,
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
