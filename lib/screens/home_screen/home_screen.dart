import 'package:flutter/material.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/screens/course_detail/course_detail_screen.dart';

import '../../widgets/others/calendar.dart';

class HomeScreen extends StatelessWidget {
  static const String route = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGray,
                        foregroundColor: AppColors.darkGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.search),
                        title: Text("Tìm kiếm"),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications_none, size: 30),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.errorRed,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "99+",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Thành tựu", style: AppTextStyles.title),
              ),
              SizedBox(height: 16),
              calendar(width),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Chủ đề", style: AppTextStyles.title),
              ),
              SizedBox(height: 16),
              CourseCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed(CourseDetailScreen.route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGray, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Tiêu đề", style: AppTextStyles.title),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Thuật ngữ", style: AppTextStyles.bodySmall),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Text("Username", style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
