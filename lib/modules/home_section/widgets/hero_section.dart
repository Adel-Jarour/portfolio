import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/modules/home_section/controllers/hero_anim_controller.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HeroSection extends GetView<HeroAnimController> {
  final Key? sectionKey;
  const HeroSection({super.key, this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: const Key('hero-section'),
      onVisibilityChanged: controller.onVisibility,
      child: Container(
        key: sectionKey,
        width: double.infinity,
        color: isDark ? AppColors.darkBackground : AppColors.background,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? AppSizes.pagePaddingMobile
              : isTablet
                  ? AppSizes.pagePaddingTablet
                  : AppSizes.pagePaddingDesktop,
          vertical: isMobile ? AppSizes.xxl : AppSizes.xxxl + 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: isMobile || isTablet
                ? _buildMobileLayout(isMobile, isDark)
                : _buildDesktopLayout(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: AnimatedFadeSlide(
            animation: controller.animCtrl,
            beginOffset: const Offset(-0.12, 0),
            child: _buildTextContent(false, isDark),
          ),
        ),
        const SizedBox(width: AppSizes.xxl),
        Expanded(
          flex: 5,
          child: AnimatedFadeSlide(
            animation: controller.animCtrl,
            beginOffset: const Offset(0.12, 0),
            child: _buildProfileImage(false),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile, bool isDark) {
    return Column(
      children: [
        AnimatedFadeSlide(
          animation: controller.animCtrl,
          beginOffset: const Offset(-0.1, 0),
          child: _buildTextContent(true, isDark),
        ),
        const SizedBox(height: AppSizes.xl),
        AnimatedFadeSlide(
          animation: controller.animCtrl,
          beginOffset: const Offset(0.1, 0),
          child: _buildProfileImage(true),
        ),
      ],
    );
  }

  Widget _buildTextContent(bool isMobile, bool isDark) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBadgeBg : AppColors.badgeBg,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: CustomText(
            text: Strings.availableForProjects.tr,
            style: CustomTextStyle.caption,
            color: isDark ? AppColors.darkBadgeText : AppColors.badgeText,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSizes.lg),

        // Heading
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.heroTitle1.tr,
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 36 : 52,
                  color: isDark ? AppColors.darkText : null,
                ),
              ),
              TextSpan(
                text: Strings.heroTitleHighlight.tr,
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 36 : 52,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: Strings.heroTitle2.tr,
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 36 : 52,
                  color: isDark ? AppColors.darkText : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.lg),

        // Subtitle
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 420,
          ),
          child: CustomText(
            text: Strings.heroSubtitle.tr,
            style: CustomTextStyle.bodyMedium,
            color: isDark ? AppColors.darkTextSecondary : null,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
        const SizedBox(height: AppSizes.xl),

        // Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            CustomButton(
              text: Strings.hireMe.tr,
              variant: CustomButtonVariant.filled,
              onPressed: () {},
            ),
            const SizedBox(width: AppSizes.md),
            CustomButton(
              text: Strings.viewPortfolio.tr,
              variant: CustomButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage(bool isMobile) {
    final imageSize = isMobile ? 280.0 : 420.0;

    return Center(
      child: Container(
        width: imageSize,
        height: imageSize + 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5E6DA), Color(0xFFEED9CC)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                child: Image.asset(
                  'assets/images/profile_photo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
              child: CustomText(
                text: Strings.professionalProfile.tr,
                style: CustomTextStyle.bodySmall,
                color: AppColors.textPrimary.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
