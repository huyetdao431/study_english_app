import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/screens/home_screen/cubit/home_cubit.dart';
import 'package:study_english_app/screens/home_screen/notification_screen.dart';
import 'package:study_english_app/screens/search_screen/search_screen.dart';

import '../../services/api.dart';
import '../../widgets/others/calendar.dart';

class HomeScreen extends StatelessWidget {
  static const String route = "HomeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(context.read<Api>()),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        return SafeArea(
          child:
              cubit.state.loadStatus == LoadStatus.Loading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                    onRefresh: () async{
                      cubit.fetchData();
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      cubit.state.userInfo.avt.isNotEmpty
                                          ? CircleAvatar(
                                            radius: 28,
                                            backgroundImage:
                                                Image.asset(
                                                  cubit.state.userInfo.avt,
                                                ).image,
                                          )
                                          : Container(
                                            alignment: Alignment.center,
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: AppColors.darkWhite,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.primaryDark,
                                                width: 2,
                                              ),
                                            ),
                                            child: Text(
                                              cubit
                                                      .state
                                                      .userInfo
                                                      .username
                                                      .isEmpty
                                                  ? 'U'
                                                  : cubit
                                                      .state
                                                      .userInfo
                                                      .username[0]
                                                      .toUpperCase(),
                                              style: AppTextStyles.body.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Xin chào, ${cubit.state.userInfo.username}!",
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed(NotificationScreen.route);
                                      },
                                      icon: Icon(
                                        Icons.notifications_none,
                                        size: 30,
                                      ),
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
                              child: Text(
                                "Thành tựu",
                                style: AppTextStyles.title,
                              ),
                            ),
                            SizedBox(height: 16),
                            calendar(width, cubit.state.streak),
                            cubit.state.latestCourse.isEmpty
                                ? SizedBox()
                                : Column(
                                  children: [
                                    SizedBox(height: 32),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Khóa học gần đây",
                                        style: AppTextStyles.title,
                                      ),
                                    ),
                                    CourseCard(
                                      course: cubit.state.latestCourse,
                                      popUpMenuItem: Container(),
                                    ),
                                  ],
                                ),
                            SizedBox(height: 32),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Khóa học đề xuất",
                                style: AppTextStyles.title,
                              ),
                            ),
                            for (var course in cubit.state.suggestCourse)
                              CourseCard(
                                course: course,
                                popUpMenuItem: Container(),
                              ),
                            SizedBox(height: 32),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tham gia khóa học để bắt đầu học tập",
                                style: AppTextStyles.title,
                              ),
                            ),
                            SizedBox(height: 16),
                            NavigatorLabel(
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(SearchScreen.route);
                              },
                              title: 'Tìm kiếm khóa học',
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
        );
      },
    );
  }
}

class NavigatorLabel extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NavigatorLabel({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: AppColors.darkWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        highlightColor: AppColors.primaryLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.body),
              SizedBox(height: 32),
              Icon(Icons.navigate_next, color: AppColors.darkGray),
            ],
          ),
        ),
      ),
    );
  }
}
