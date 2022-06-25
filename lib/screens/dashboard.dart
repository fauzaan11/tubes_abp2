import 'package:flutter/material.dart';
import 'package:mobile/components/bottomNavBar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: BottomNavigationbar()),
    );
  }
}
