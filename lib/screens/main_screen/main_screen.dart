import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/screens/add_course_screen/add_course_screen.dart';
import 'package:study_english_app/screens/library_screen/library_screen.dart';
import '../account_screen/account_screen.dart';
import '../home_screen/home_screen.dart';

class MainScreen extends StatefulWidget {
  static const String route = "MainScreen";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AccountScreen(),
    Container(),
    LibraryScreen(),
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
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: AppColors.primaryDark,
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              builder: (context) => _buildBottomSheet(context),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: 'Mini Game'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 35), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.folder_copy), label: 'Thư viện'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tôi'),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.pop(context); // Đóng bottom sheet
              Navigator.pushNamed(context, AddCourseScreen.route, arguments: {
                'isAddCourse': true,
                'courseId': '',
              });
            },
            child: Row(
              children: const [
                Icon(Icons.add, size: 24),
                SizedBox(width: 8),
                Text('Tạo mới khóa học', style: TextStyle(fontSize: 18)),
                Spacer(),
                Icon(Icons.navigate_next),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

}
