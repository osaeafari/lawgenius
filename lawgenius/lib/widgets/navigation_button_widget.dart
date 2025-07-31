import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';

class NavigationButton extends StatelessWidget {
  final String label;
  final String route;
  final dynamic extra; // optional, e.g. OrderData or any object
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const NavigationButton({
    super.key,
    required this.label,
    required this.route,
    this.extra,
    this.width,
    this.height,
    this.fontSize,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,

      child: ElevatedButton(
        onPressed: () {
          context.push(route, extra: extra);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        ),
        child: Text(label, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
