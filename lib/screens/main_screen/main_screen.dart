import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:study_english_app/core/color.dart';
import '../account_screen/account_screen.dart';
import '../home_screen/home_screen.dart';
import '../mini_game_screen/mini_game_screen.dart';
import '../statisticial_screen/statistical_screen.dart';
import '../suggest_screen/suggest_screen.dart';

class MainScreen extends StatefulWidget {
  static const String route = "MainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    MiniGameScreen(),
    StatisticalScreen(),
    SuggestScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle, // Các kiểu: fixed, react, reactive, flip, textIn, etc.
        backgroundColor: AppColors.primaryDark,
        items: const [
          TabItem(icon: Icons.home, title: 'Trang chủ'),
          TabItem(icon: Icons.videogame_asset, title: 'Mini Game'),
          TabItem(icon: Icon(Icons.add, size: 30,),title: ''),
          TabItem(icon: Icons.lightbulb, title: 'Gợi ý'),
          TabItem(icon: Icons.person, title: 'Tôi'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
