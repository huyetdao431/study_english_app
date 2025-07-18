import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';

import '../../core/color.dart';
import '../../core/text.dart';

class AchievementScreen extends StatelessWidget {
  static const String route = 'AchievementScreen';

  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thành tựu'),
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Page(streak: context.read<AccountCubit>().state.streak),
          );
        },
      ),
    );
  }
}

class Page extends StatefulWidget {
  final Map<String, dynamic> streak;

  const Page({super.key, required this.streak});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    final streakDates =
        (widget.streak['streakHistory'] != null)
            ? (widget.streak['streakHistory'] as List<dynamic>)
                .map((date) => DateTime.parse(date as String))
                .toList()
            : [];

    final now = DateTime.now();

    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final daysInMonth = lastDayOfMonth.day;

    final startWeekday = firstDayOfMonth.weekday;
    // 1 = Monday, 7 = Sunday
    final totalCells = ((startWeekday - 1) + daysInMonth + 6) ~/ 7 * 7;
    // Bội số của 7
    final dayOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final double width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width - 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray, width: 2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            "Chuỗi ${widget.streak['streak']} ngày",
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 16),
          Icon(FontAwesomeIcons.fire, size: 80, color: AppColors.warningOrange),
          const SizedBox(height: 16),
          Text("Hãy học để duy trì chuỗi của bạn!", style: AppTextStyles.title),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                return Text(dayOfWeek[i], style: AppTextStyles.bold);
              }),
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalCells,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final dayNumber = index - (startWeekday - 1) + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox(); // empty cell
                }

                final currentDay = DateTime(now.year, now.month, dayNumber);
                final isStreak = streakDates.any(
                  (d) =>
                      d.year == currentDay.year &&
                      d.month == currentDay.month &&
                      d.day == currentDay.day,
                );

                // Kiểm tra liền kề
                final prevDay = currentDay.subtract(const Duration(days: 1));
                final nextDay = currentDay.add(const Duration(days: 1));

                final prevIsStreak = streakDates.any(
                  (d) =>
                      d.year == prevDay.year &&
                      d.month == prevDay.month &&
                      d.day == prevDay.day,
                );
                final nextIsStreak = streakDates.any(
                  (d) =>
                      d.year == nextDay.year &&
                      d.month == nextDay.month &&
                      d.day == nextDay.day,
                );

                BorderRadius radius = BorderRadius.zero;
                if (isStreak) {
                  if (!prevIsStreak && !nextIsStreak) {
                    radius = BorderRadius.circular(16);
                  } else if (!prevIsStreak && nextIsStreak) {
                    radius = const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    );
                  } else if (prevIsStreak && !nextIsStreak) {
                    radius = const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    );
                  }
                }

                return Container(
                  decoration: BoxDecoration(
                    color:
                        isStreak
                            ? AppColors.warningOrange.withAlpha(50)
                            : null,
                    borderRadius: radius,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isStreak)
                          Icon(
                            FontAwesomeIcons.fireFlameSimple,
                            size: 24,
                            color: AppColors.warningOrange,
                          ),
                        if (!isStreak)
                          Text('$dayNumber', style: AppTextStyles.bold),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
