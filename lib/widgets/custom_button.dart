import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/core/constants/app_sizes.dart';

enum CustomButtonVariant { filled, outlined }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = CustomButtonVariant.filled,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.variant == CustomButtonVariant.filled;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: widget.width,
          height: widget.height ?? 46,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.sm + 2,
          ),
          decoration: BoxDecoration(
            color: isFilled
                ? (_isHovered ? AppColors.primaryDark : AppColors.primary)
                : (_isHovered
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: isFilled
                ? null
                : Border.all(
                    color: _isHovered ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
            boxShadow: isFilled && _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isFilled ? AppColors.textWhite : AppColors.primary,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 18,
                          color: isFilled
                              ? AppColors.textWhite
                              : (_isHovered
                                  ? AppColors.primary
                                  : AppColors.textPrimary),
                        ),
                        const SizedBox(width: AppSizes.sm),
                      ],
                      Text(
                        widget.text,
                        style: AppTextStyles.button.copyWith(
                          color: isFilled
                              ? AppColors.textWhite
                              : (_isHovered
                                  ? AppColors.primary
                                  : AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
