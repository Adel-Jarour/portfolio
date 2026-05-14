import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/custom_text.dart';

class StatsRow extends StatelessWidget {
  final bool isDark;
  final int projects;
  final int clients;
  final int yearsExp;

  const StatsRow({
    super.key,
    this.isDark = false,
    this.projects = 0,
    this.clients = 0,
    this.yearsExp = 0,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(value: projects, labelKey: Strings.statProjects),
      _StatData(value: clients, labelKey: Strings.statClients),
      _StatData(value: yearsExp, labelKey: Strings.statExperience),
    ];

    return Row(
      children: List.generate(stats.length, (index) {
        final stat = stats[index];
        return Padding(
          padding: EdgeInsets.only(
            right: index < stats.length - 1 ? AppSizes.xl + 8 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: '${stat.value}+',
                style: CustomTextStyle.h2,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: stat.labelKey.tr,
                style: CustomTextStyle.caption,
                fontSize: 10,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatData {
  final int value;
  final String labelKey;

  const _StatData({required this.value, required this.labelKey});
}
