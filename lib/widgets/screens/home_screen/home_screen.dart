import 'package:flutter/material.dart';
import 'package:study_english_app/widgets/screens/account_screen/account_screen.dart';
import 'package:study_english_app/widgets/screens/flashcard_screen/flashcard_screen.dart';
import 'package:study_english_app/widgets/screens/mini_game_screen/mini_game_screen.dart';
import 'package:study_english_app/widgets/screens/statisticial_screen/statistical_screen.dart';
import 'package:study_english_app/widgets/screens/suggest_screen/suggest_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    FlashcardScreen(),
    MiniGameScreen(),
    StatisticalScreen(),
    SuggestScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Màu khi được chọn
        unselectedItemColor: Colors.grey, // Màu khi không được chọn
        type: BottomNavigationBarType.fixed, // Giữ kích thước cố định
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Flashcard'),
          BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: 'Mini-Game'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistical'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Suggest'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
