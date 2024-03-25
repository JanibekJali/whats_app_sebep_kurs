import 'package:flutter/material.dart';
import 'package:whats_app_sebep_kurs/constants/colors/app_colors.dart';
import 'package:whats_app_sebep_kurs/constants/text_styles/app_text_styles.dart';

class CustomMainButton extends StatelessWidget {
  const CustomMainButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });
  final String buttonText;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.teal,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: AppTextStyles.blue25Bold,
            ),
          ),
        ),
      ),
    );
  }
}
