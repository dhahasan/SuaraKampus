import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  danger,
  dangerOutline,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final double? width;
  final double borderRadius;
  final double fontSize;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.height = 42,
    this.width,
    this.borderRadius = 11,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide? border;

    switch (type) {
      case AppButtonType.primary:
        bgColor = AppColors.primary;
        fgColor = Colors.white;
        border = null;
        break;
      case AppButtonType.secondary:
        bgColor = AppColors.secondaryButtonBg;
        fgColor = AppColors.primary;
        border = null;
        break;
      case AppButtonType.outline:
        bgColor = Colors.white;
        fgColor = AppColors.primary;
        border = const BorderSide(color: AppColors.primary, width: 1.2);
        break;
      case AppButtonType.danger:
        bgColor = AppColors.dangerRed;
        fgColor = Colors.white;
        border = null;
        break;
      case AppButtonType.dangerOutline:
        bgColor = Colors.white;
        fgColor = AppColors.dangerRed;
        border = const BorderSide(color: AppColors.dangerRed, width: 1.2);
        break;
    }

    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: isEnabled ? bgColor : Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: border ?? BorderSide.none,
        ),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 16,
                            color: isEnabled ? fgColor : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: isEnabled ? fgColor : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
