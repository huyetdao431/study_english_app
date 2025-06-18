import 'package:flutter/material.dart';
import 'package:study_english_app/core/color.dart';

Ink primaryButton(bool hasIcon, String text, double? fontSize, VoidCallback onTap) {
  return Ink(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: AppColors.primaryBlue,
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      highlightColor: AppColors.primaryDark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hasIcon ? Icon(Icons.g_mobiledata_outlined, color: Colors.white,) : SizedBox(),
          hasIcon ? SizedBox(width: 10, height: 60,) : SizedBox(height: 60,),
          Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),),
        ],
      ),
    ),
  );
}
