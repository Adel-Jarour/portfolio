import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
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
    final AppController controller = Get.find();
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
              onPressed: () {
                controller.scrollToSection(4);
              },
            ),
            const SizedBox(width: AppSizes.md),
            CustomButton(
              text: Strings.viewPortfolio.tr,
              variant: CustomButtonVariant.outlined,
              onPressed: () {
                controller.scrollToSection(3);
              },
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
                child: Obx(() {
                  final imageUrl = controller.portfolioInfo.value?.image;
                  final isLoading = controller.isLoading.value;

                  if (isLoading || imageUrl == null || imageUrl.isEmpty) {
                    return const SkeletonLoader(
                      width: double.infinity,
                      height: double.infinity,
                    );
                  }

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SkeletonLoader(
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const SkeletonLoader(
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16.0,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkBorder : AppColors.borderLight;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}
