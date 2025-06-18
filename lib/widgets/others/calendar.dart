import 'package:flutter/material.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';

Widget calendar(double width) {
  DateTime dateTime = DateTime.now();
  int weekday = dateTime.weekday;
  int day = dateTime.day;
  int month = dateTime.month;
  int year = dateTime.year;
  var monthsHave31Days = [1, 3, 5, 7, 8, 10, 12];
  var dayOfWeek = ['Mon', 'Tue', 'Wed', "Thu", 'Fri', 'Sat', 'Sun'];
  var weekdays = [];
  for (int i = weekday - 1; i >= 1; i--) {
    if (day - i < 0) {
      if (month == 2) {
        if (isLeapYear(year)) {
          weekday = 29;
        } else {
          weekday = 28;
        }
      } else if (monthsHave31Days.contains(month)) {
        weekday = 30;
      } else {
        weekday = 31;
      }
    }
    weekdays.add(day - i);
  }
  weekday = dateTime.weekday;
  for (int i = 0; i <= 7 - weekday; i++) {
    if (month == 2) {
      if (isLeapYear(year)) {
        if (day + i > 29) {
          day = 1;
        }
      } else {
        if (day + i > 28) {
          day = 1;
        }
      }
    } else if (monthsHave31Days.contains(month)) {
      if (day + i > 30) {
        day = 1;
      }
    } else {
      if (day + i > 31) {
        day = 1;
      }
    }
    weekdays.add(day + i);
  }
  return Container(
    width: width - 16,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.lightGray, width: 2),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 8,),
        Text("Chuỗi 1 tuần", style: AppTextStyles.title),
        SizedBox(height: 16),
        Icon(Icons.calendar_month, size: 100, color: AppColors.warningOrange,),
        SizedBox(height: 16),
        Text("Hãy học để duy trì chuỗi của bạn!", style: AppTextStyles.title),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < 7; i++)
                Column(
                  children: [
                    Text(dayOfWeek[i].toString(), style: AppTextStyles.bold),
                    SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warningOrange,
                      ),
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: Center(
                          child: Text(
                            weekdays[i].toString(),
                            style: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: 16,)
      ],
    ),
  );
}

bool isLeapYear(int year) {
  if (year % 4 != 0) return false;
  if (year % 100 != 0) return true;
  if (year % 400 != 0) return false;
  return true;
}
