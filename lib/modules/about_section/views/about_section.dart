import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/modules/about_section/widgets/experience_timeline.dart';
import 'package:portfolio/modules/about_section/widgets/stats_row.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutSection extends StatefulWidget {
  final Key? sectionKey;
  const AboutSection({super.key, this.sectionKey});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _animated = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: _onVisibility,
      child: Container(
        key: widget.sectionKey,
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
            child: Column(
              children: [
                AnimatedFadeSlide(
                  animation: _ctrl,
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
                    ? _buildMobileLayout(isDark)
                    : _buildDesktopLayout(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: AnimatedFadeSlide(
            animation: _ctrl,
            beginOffset: const Offset(-0.12, 0),
            child: _buildBioContent(isDark),
          ),
        ),
        const SizedBox(width: AppSizes.xxxl),
        Expanded(
          flex: 5,
          child: AnimatedFadeSlide(
            animation: _ctrl,
            beginOffset: const Offset(0.12, 0),
            child: ExperienceTimeline(isDark: isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isDark) {
    return Column(
      children: [
        AnimatedFadeSlide(
          animation: _ctrl,
          beginOffset: const Offset(-0.1, 0),
          child: _buildBioContent(isDark),
        ),
        const SizedBox(height: AppSizes.xl),
        AnimatedFadeSlide(
          animation: _ctrl,
          beginOffset: const Offset(0.1, 0),
          child: ExperienceTimeline(isDark: isDark),
        ),
      ],
    );
  }

  Widget _buildBioContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: Strings.aboutP1.tr,
          style: CustomTextStyle.bodyMedium,
          color: isDark ? AppColors.darkTextSecondary : null,
          height: 1.8,
        ),
        const SizedBox(height: AppSizes.lg),
        CustomText(
          text: Strings.aboutP2.tr,
          style: CustomTextStyle.bodyMedium,
          color: isDark ? AppColors.darkTextSecondary : null,
          height: 1.8,
        ),
        const SizedBox(height: AppSizes.xl + 8),
        StatsRow(isDark: isDark),
      ],
    );
  }
}
