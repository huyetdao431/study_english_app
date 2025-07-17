import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/screens/course_detail/course_detail_screen.dart';
import 'package:study_english_app/screens/home_screen/cubit/home_cubit.dart';

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
      context.read<HomeCubit>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        return SafeArea(
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
                            cubit.state.userInfo.avt.isNotEmpty ? CircleAvatar(
                              radius: 24,
                              backgroundImage: Image.asset(cubit.state.userInfo.avt).image,
                            ) : Container(
                              alignment: Alignment.center,
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.darkWhite,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cubit.state.userInfo.username[0].toUpperCase() ?? '',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Xin chào, ${cubit.state.userInfo.username??''}!",
                              style: AppTextStyles.body.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
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
                  NavigatorLabel(onTap: () {}, title: 'Tìm kiếm khóa học'),
                  SizedBox(height: 16),
                  NavigatorLabel(
                    onTap: () {},
                    title: 'Học các bộ từ theo chủ đề',
                  ),
                ],
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
