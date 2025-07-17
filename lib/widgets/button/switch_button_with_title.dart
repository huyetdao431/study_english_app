import 'package:flutter/material.dart';
import '../../core/color.dart';

class SwitchButtonWithTitle extends StatelessWidget {
  final String title;
  final Function(bool) onChanged;
  final bool value;

  const SwitchButtonWithTitle({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        Switch(
          value: value,
          onChanged: (value) => onChanged(value),
          activeColor: AppColors.white,
          activeTrackColor: AppColors.primaryBlue,
          inactiveThumbColor: AppColors.white,
          inactiveTrackColor: AppColors.secondaryGray,
        ),
      ],
    );
  }
}
