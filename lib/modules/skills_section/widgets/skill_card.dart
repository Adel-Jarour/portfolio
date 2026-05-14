import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/widgets/custom_text.dart';

class SkillCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> tags;
  final bool isDark;

  const SkillCard({
    super.key,
    required this.icon,
    required this.title,
    required this.tags,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: AppSizes.lg),
          // Category title
          CustomText(
            text: title,
            style: CustomTextStyle.h4,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : null,
          ),
          const SizedBox(height: AppSizes.lg),
          // Skill tags (pill badges)
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: tags
                .map((tag) => _SkillTag(text: tag, isDark: isDark))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillTag extends StatelessWidget {
  final String text;
  final bool isDark;

  const _SkillTag({required this.text, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBadgeBg : AppColors.badgeBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: CustomText(
        text: text,
        style: CustomTextStyle.bodySmall,
        color: isDark ? AppColors.darkBadgeText : AppColors.primaryLight,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
