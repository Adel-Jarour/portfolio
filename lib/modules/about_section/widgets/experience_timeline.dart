import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/custom_text.dart';

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ExperienceData(
        icon: Icons.design_services_outlined,
        titleKey: Strings.exp1Title,
        companyKey: Strings.exp1Company,
        descKey: Strings.exp1Desc,
      ),
      _ExperienceData(
        icon: Icons.code_rounded,
        titleKey: Strings.exp2Title,
        companyKey: Strings.exp2Company,
        descKey: Strings.exp2Desc,
      ),
      _ExperienceData(
        icon: Icons.school_outlined,
        titleKey: Strings.exp3Title,
        companyKey: Strings.exp3Company,
        descKey: Strings.exp3Desc,
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
                      CustomText(
                        text: item.titleKey.tr,
                        style: CustomTextStyle.h4,
                        fontSize: 17,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: item.companyKey.tr,
                        style: CustomTextStyle.bodySmall,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      CustomText(
                        text: item.descKey.tr,
                        style: CustomTextStyle.bodySmall,
                        color: AppColors.textSecondary,
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
