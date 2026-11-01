import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AppBadgeType {
  primary,
  success,
  warning,
  danger,
  neutral,
}

class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeType type;
  final IconData? icon;
  final bool showDot;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const AppBadge({
    super.key,
    required this.text,
    this.type = AppBadgeType.primary,
    this.icon,
    this.showDot = false,
    this.fontSize = 9.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (type) {
      case AppBadgeType.primary:
        bg = AppColors.infoBg;
        fg = AppColors.primary;
        border = AppColors.borderCard;
        break;
      case AppBadgeType.success:
        bg = AppColors.successBg;
        fg = AppColors.successGreen;
        border = AppColors.successBorder;
        break;
      case AppBadgeType.warning:
        bg = AppColors.pendingBg;
        fg = AppColors.pendingAmber;
        border = AppColors.pendingBorder;
        break;
      case AppBadgeType.danger:
        bg = AppColors.dangerBg;
        fg = AppColors.dangerRed;
        border = AppColors.dangerBorder;
        break;
      case AppBadgeType.neutral:
        bg = Colors.white;
        fg = AppColors.textSecondary;
        border = AppColors.borderCard;
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: fg,
                shape: BoxShape.circle,
              ),
            ),
          ],
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg),
            const SizedBox(width: 3),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
