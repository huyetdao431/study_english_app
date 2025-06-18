import 'package:flutter/material.dart';

import 'color.dart';

class AppTextStyles {
  // Display: 32–40px, Bold / ExtraBold
  static const TextStyle display = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  // Headline: 24px, Bold
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // Subhead: 20px, Medium
  static const TextStyle subhead = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  // Title: 18px, Medium / SemiBold
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Body: 16px, Regular / Medium
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Body Small: 14px, Regular
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Caption: 12px, Regular / Italic
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
  );

  // Button: 16px, SemiBold / Bold
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  // Button: 16px, SemiBold / Bold
  static const TextStyle primaryButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkWhite,
  );

  // Tag / Chip: 12–14px, Medium
  static const TextStyle chip = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  // bold
  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold,
  );
}
