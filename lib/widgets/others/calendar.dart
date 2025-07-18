import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';

Widget calendar(double width, Map<String, dynamic> streak) {
  final streakDates =
      (streak['streakHistory'] != null)
          ? (streak['streakHistory'] as List<dynamic>)
              .map((date) => DateTime.parse(date as String))
              .toList()
          : [];
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
  final days = List.generate(
    7,
    (index) => startOfWeek.add(Duration(days: index)),
  );
  final dayOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return Container(
    width: width - 16,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.lightGray, width: 2),
    ),
    child: Column(
      children: [
        const SizedBox(height: 8),
        Text("Chuỗi ${streak['streak']} ngày", style: AppTextStyles.title),
        const SizedBox(height: 16),
        Icon(FontAwesomeIcons.fire, size: 80, color: AppColors.warningOrange),
        const SizedBox(height: 16),
        Text("Hãy học để duy trì chuỗi của bạn!", style: AppTextStyles.title),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 34),
                height: 36,
                width: width,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: List.generate(7, (i) {
                    final day = days[i];
                    final isStreak = streakDates.any((d) =>
                    d.year == day.year && d.month == day.month && d.day == day.day);

                    final prevIsStreak = i > 0
                        ? streakDates.any((d) =>
                    d.year == days[i - 1].year &&
                        d.month == days[i - 1].month &&
                        d.day == days[i - 1].day)
                        : false;

                    final nextIsStreak = i < 6
                        ? streakDates.any((d) =>
                    d.year == days[i + 1].year &&
                        d.month == days[i + 1].month &&
                        d.day == days[i + 1].day)
                        : false;

                    BorderRadius radius = BorderRadius.zero;
                    if (isStreak) {
                      if (!prevIsStreak && !nextIsStreak) {
                        // đứng một mình
                        radius = BorderRadius.circular(16);
                      } else if (!prevIsStreak && nextIsStreak) {
                        // bắt đầu chuỗi
                        radius = const BorderRadius.horizontal(left: Radius.circular(16));
                      } else if (prevIsStreak && !nextIsStreak) {
                        // kết thúc chuỗi
                        radius = const BorderRadius.horizontal(right: Radius.circular(16));
                      }
                      // nếu ở giữa chuỗi thì không cần bo
                    }

                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isStreak
                              ? AppColors.warningOrange.withAlpha(50)
                              : AppColors.lightGray,
                          borderRadius: radius,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (i) {
                  final day = days[i];
                  final isStreak = streakDates.any(
                        (d) =>
                    d.year == day.year &&
                        d.month == day.month &&
                        d.day == day.day,
                  );

                  return Column(
                    children: [
                      Text(dayOfWeek[i], style: AppTextStyles.bold),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          isStreak
                              ? Icon(
                            FontAwesomeIcons.fireFlameSimple,
                            size: 32,
                            color: AppColors.warningOrange,
                          )
                              : SizedBox(),
                          SizedBox(
                            height: 32,
                            width: 32,
                            child: Center(child: !isStreak ? Text('${day.day}', style: TextStyle(fontWeight: FontWeight.bold),) : null),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ]
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
