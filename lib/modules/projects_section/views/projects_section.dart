import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/projects_section/controllers/projects_anim_controller.dart';
import 'package:portfolio/modules/projects_section/widgets/project_card.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsSection extends GetView<ProjectsAnimController> {
  final Key? sectionKey;
  const ProjectsSection({super.key, this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: const Key('projects-section'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                AnimatedFadeSlide(
                  animation: controller.headerCtrl,
                  beginOffset: const Offset(0, 0.08),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderTitles(isDark),
                            const SizedBox(height: AppSizes.lg),
                            _buildViewArchiveBtn(),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildHeaderTitles(isDark),
                            _buildViewArchiveBtn(),
                          ],
                        ),
                ),

                const SizedBox(height: AppSizes.xxl),

                // Cards
                if (isMobile || isTablet)
                  Column(
                    children: [
                      AnimatedFadeSlide(
                        animation: controller.card1Ctrl,
                        beginOffset: const Offset(0, 0.12),
                        child: _buildCard1(isDark),
                      ),
                      const SizedBox(height: AppSizes.xl),
                      AnimatedFadeSlide(
                        animation: controller.card2Ctrl,
                        beginOffset: const Offset(0, 0.12),
                        child: _buildCard2(isDark),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedFadeSlide(
                          animation: controller.card1Ctrl,
                          beginOffset: const Offset(0, 0.12),
                          child: _buildCard1(isDark),
                        ),
                      ),
                      const SizedBox(width: AppSizes.xxl),
                      Expanded(
                        child: AnimatedFadeSlide(
                          animation: controller.card2Ctrl,
                          beginOffset: const Offset(0, 0.12),
                          child: _buildCard2(isDark),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitles(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: Strings.selectedWorks.tr,
          style: CustomTextStyle.h2,
          color: isDark ? AppColors.darkText : null,
        ),
        const SizedBox(height: AppSizes.sm),
        CustomText(
          text: Strings.selectedWorksSubtitle.tr,
          style: CustomTextStyle.bodyMedium,
          color:
              isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildViewArchiveBtn() {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: Strings.viewArchive.tr,
            style: CustomTextStyle.button,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSizes.sm),
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildCard1(bool isDark) {
    return ProjectCard(
      imageUrl: '',
      category: Strings.project1Category.tr,
      year: Strings.project1Year.tr,
      title: Strings.project1Title.tr,
      description: Strings.project1Desc.tr,
      technologies: const ['React', 'D3.js', 'Supabase'],
      isDark: isDark,
    );
  }

  Widget _buildCard2(bool isDark) {
    return ProjectCard(
      imageUrl: '',
      category: Strings.project2Category.tr,
      year: Strings.project2Year.tr,
      title: Strings.project2Title.tr,
      description: Strings.project2Desc.tr,
      technologies: const ['Next.js', 'Shopify', 'Stripe'],
      isDark: isDark,
    );
  }
}
