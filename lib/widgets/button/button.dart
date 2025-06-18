import 'package:flutter/material.dart';
import 'package:study_english_app/core/color.dart';

Ink button(bool hasIcon, String text, double? fontSize, VoidCallback onTap) {
  return Ink(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: AppColors.lightGray, width: 2),
      color: AppColors.darkWhite,
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(27),
      highlightColor: AppColors.primaryLight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hasIcon ? Icon(Icons.mail_outline) : SizedBox(),
          hasIcon ? SizedBox(width: 10, height: 56,) : SizedBox(height: 56,),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
        ],
      ),
    ),
  );
}
