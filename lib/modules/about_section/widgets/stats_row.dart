import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(valueKey: 'stat_projects_value', labelKey: 'stat_projects'),
      _StatData(valueKey: 'stat_clients_value', labelKey: 'stat_clients'),
      _StatData(valueKey: 'stat_experience_value', labelKey: 'stat_experience'),
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
              Text(
                stat.valueKey.tr,
                style: AppTextStyles.h2.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.labelKey.tr,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatData {
  final String valueKey;
  final String labelKey;

  const _StatData({required this.valueKey, required this.labelKey});
}
