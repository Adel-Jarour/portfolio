import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ExperienceData(
        icon: Icons.design_services_outlined,
        titleKey: 'exp1_title',
        companyKey: 'exp1_company',
        descKey: 'exp1_desc',
      ),
      _ExperienceData(
        icon: Icons.code_rounded,
        titleKey: 'exp2_title',
        companyKey: 'exp2_company',
        descKey: 'exp2_desc',
      ),
      _ExperienceData(
        icon: Icons.school_outlined,
        titleKey: 'exp3_title',
        companyKey: 'exp3_company',
        descKey: 'exp3_desc',
      ),
    ];

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line + icon
              SizedBox(
                width: 48,
                child: Column(
                  children: [
                    // Icon circle
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    // Vertical connector line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.md),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : AppSizes.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.titleKey.tr,
                        style: AppTextStyles.h4.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.companyKey.tr,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        item.descKey.tr,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ExperienceData {
  final IconData icon;
  final String titleKey;
  final String companyKey;
  final String descKey;

  const _ExperienceData({
    required this.icon,
    required this.titleKey,
    required this.companyKey,
    required this.descKey,
  });
}
