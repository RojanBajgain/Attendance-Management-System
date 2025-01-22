import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';

import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String title;

  const LargeButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 48,
      width: double.infinity,
      child: Text(
        title,
        style: normalStyle.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
