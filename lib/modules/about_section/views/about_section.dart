import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/modules/about_section/controllers/about_controller.dart';
import 'package:portfolio/modules/about_section/widgets/experience_timeline.dart';
import 'package:portfolio/modules/about_section/widgets/stats_row.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutSection extends GetView<AboutController> {
  final Key? sectionKey;
  const AboutSection({super.key, this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: controller.onVisibility,
      child: Container(
        key: sectionKey,
        width: double.infinity,
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
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
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildSkeleton(isMobile, isDark);
              }
              if (controller.hasError.value) {
                return _buildError(isDark);
              }
              return Column(
                children: [
                  AnimatedFadeSlide(
                    animation: controller.animCtrl,
                    beginOffset: const Offset(0, 0.08),
                    child: CustomText(
                      text: Strings.aboutMe.tr,
                      style: CustomTextStyle.h2,
                      fontSize: isMobile ? 28 : 36,
                      color: isDark ? AppColors.darkText : null,
                    ),
                  ),
                  SizedBox(height: isMobile ? AppSizes.xl : AppSizes.xxl + 8),
                  isMobile || isTablet
                      ? _buildMobileLayout(isDark, controller.experiences)
                      : _buildDesktopLayout(isDark, controller.experiences),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isDark, List<ExperienceModel> experiences) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: AnimatedFadeSlide(
            animation: controller.animCtrl,
            beginOffset: const Offset(-0.12, 0),
            child: _buildBioContent(isDark),
          ),
        ),
        const SizedBox(width: AppSizes.xxxl),
        Expanded(
          flex: 5,
          child: AnimatedFadeSlide(
            animation: controller.animCtrl,
            beginOffset: const Offset(0.12, 0),
            child: ExperienceTimeline(isDark: isDark, experiences: experiences),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isDark, List<ExperienceModel> experiences) {
    return Column(
      children: [
        AnimatedFadeSlide(
          animation: controller.animCtrl,
          beginOffset: const Offset(-0.1, 0),
          child: _buildBioContent(isDark),
        ),
        const SizedBox(height: AppSizes.xl),
        AnimatedFadeSlide(
          animation: controller.animCtrl,
          beginOffset: const Offset(0.1, 0),
          child: ExperienceTimeline(isDark: isDark, experiences: experiences),
        ),
      ],
    );
  }

  Widget _buildBioContent(bool isDark) {
    final info = controller.portfolioInfo.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: info?.bio.isNotEmpty == true ? info!.bio : Strings.aboutP1.tr,
          style: CustomTextStyle.bodyMedium,
          color: isDark ? AppColors.darkTextSecondary : null,
          height: 1.8,
        ),
        const SizedBox(height: AppSizes.xl + 8),
        Obx(() => StatsRow(
              isDark: isDark,
              projects: controller.statProjects.value,
              clients: controller.statClients.value,
              yearsExp: controller.statYearsExp.value,
            )),
      ],
    );
  }


  Widget _buildSkeleton(bool isMobile, bool isDark) {
    return Column(
      children: [
        _shimmer(isDark, width: 200, height: 36),
        const SizedBox(height: 32),
        _shimmer(isDark, width: double.infinity, height: 120),
        const SizedBox(height: 16),
        _shimmer(isDark, width: double.infinity, height: 80),
      ],
    );
  }

  Widget _buildError(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded,
              size: 48,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          const SizedBox(height: 16),
          CustomText(
            text: 'Could not load about info. Check your connection.',
            style: CustomTextStyle.bodyMedium,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _shimmer(bool isDark, {double? width, required double height}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
