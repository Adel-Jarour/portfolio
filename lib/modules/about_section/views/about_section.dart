import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/modules/about_section/widgets/experience_timeline.dart';
import 'package:portfolio/modules/about_section/widgets/stats_row.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;

    return Container(
      width: double.infinity,
      color: AppColors.cardBackground,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppSizes.pagePaddingMobile
            : isTablet
                ? AppSizes.pagePaddingTablet
                : AppSizes.pagePaddingDesktop,
        vertical: AppSizes.xxxl + 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Column(
            children: [
              // Section title
              Text(
                'about_me'.tr,
                style: AppTextStyles.h2.copyWith(
                  fontSize: isMobile ? 28 : 36,
                ),
              ),
              SizedBox(height: isMobile ? AppSizes.xl : AppSizes.xxl + 8),

              // Content
              isMobile || isTablet
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left – Bio text + stats
        Expanded(
          flex: 5,
          child: _buildBioContent(),
        ),
        const SizedBox(width: AppSizes.xxxl),
        // Right – Experience timeline
        Expanded(
          flex: 5,
          child: const ExperienceTimeline(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildBioContent(),
        const SizedBox(height: AppSizes.xl),
        const ExperienceTimeline(),
      ],
    );
  }

  Widget _buildBioContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Paragraph 1
        Text(
          'about_p1'.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            height: 1.8,
          ),
        ),
        const SizedBox(height: AppSizes.lg),

        // Paragraph 2
        Text(
          'about_p2'.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            height: 1.8,
          ),
        ),
        const SizedBox(height: AppSizes.xl + 8),

        // Stats row
        const StatsRow(),
      ],
    );
  }
}
