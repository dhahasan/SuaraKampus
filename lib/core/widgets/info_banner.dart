import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum InfoBannerType { info, warning, danger, success }

class InfoBanner extends StatelessWidget {
  final String message;
  final String? title;
  final InfoBannerType type;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry margin;

  const InfoBanner({
    super.key,
    required this.message,
    this.title,
    this.type = InfoBannerType.info,
    this.icon,
    this.trailing,
    this.margin = const EdgeInsets.symmetric(vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textColor;
    IconData defaultIcon;

    switch (type) {
      case InfoBannerType.info:
        bg = AppColors.infoBg;
        border = const Color(0xFFCCE4EE);
        textColor = AppColors.primary;
        defaultIcon = Icons.info_outline;
        break;
      case InfoBannerType.warning:
        bg = AppColors.warningBg;
        border = AppColors.warningBorder;
        textColor = AppColors.warningText;
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case InfoBannerType.danger:
        bg = AppColors.dangerBg;
        border = AppColors.dangerBorder;
        textColor = AppColors.dangerRed;
        defaultIcon = Icons.error_outline;
        break;
      case InfoBannerType.success:
        bg = AppColors.successBg;
        border = AppColors.successBorder;
        textColor = AppColors.successGreen;
        defaultIcon = Icons.check_circle_outline;
        break;
    }

    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? defaultIcon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
