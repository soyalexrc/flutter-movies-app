import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  final Widget childView;

  const HomeScreen({Key? key, required this.childView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: childView
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}


