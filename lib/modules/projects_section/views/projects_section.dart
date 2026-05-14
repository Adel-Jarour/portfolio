import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/projects_section/controllers/projects_controller.dart';
import 'package:portfolio/modules/projects_section/widgets/project_card.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsSection extends GetView<ProjectsController> {
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
                // ── Header ─────────────────────────────────────────────────
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

                // ── Cards (reactive) ────────────────────────────────────────
                Obx(() {
                  if (controller.isLoading.value) {
                    return _buildSkeleton(isMobile || isTablet, isDark);
                  }
                  if (controller.hasError.value) {
                    return _buildError(isDark);
                  }

                  final projects = controller.projects;
                  if (projects.isEmpty) return const SizedBox.shrink();

                  final animations = [
                    controller.card1Ctrl,
                    controller.card2Ctrl,
                  ];

                  final cards = List.generate(
                    projects.length,
                    (i) => AnimatedFadeSlide(
                      animation: i < animations.length
                          ? animations[i]
                          : animations.last,
                      beginOffset: const Offset(0, 0.12),
                      child: ProjectCard(
                        key: ValueKey(projects[i].id),
                        title: projects[i].name,
                        category: projects[i].status,
                        year: '',
                        description: projects[i].description,
                        technologies: const [],
                        codeUrl: projects[i].code,
                        isDark: isDark,
                      ),
                    ),
                  );

                  if (isMobile || isTablet) {
                    return Column(
                      children: List.generate(
                        cards.length,
                        (i) => Padding(
                          padding: EdgeInsets.only(
                              bottom: i < cards.length - 1 ? AppSizes.xl : 0),
                          child: cards[i],
                        ),
                      ),
                    );
                  }

                  return Row(
                    children: List.generate(
                      cards.length,
                      (i) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: i < cards.length - 1 ? AppSizes.xxl : 0),
                          child: cards[i],
                        ),
                      ),
                    ),
                  );
                }),
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
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
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

  Widget _buildSkeleton(bool stacked, bool isDark) {
    final box = Container(
      height: 320,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
    );
    if (stacked) {
      return Column(children: [
        box,
        const SizedBox(height: AppSizes.xl),
        box,
      ]);
    }
    return Row(children: [
      Expanded(child: box),
      const SizedBox(width: AppSizes.xxl),
      Expanded(child: box),
    ]);
  }

  Widget _buildError(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded,
              size: 48,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary),
          const SizedBox(height: 16),
          CustomText(
            text: 'Could not load projects. Check your connection.',
            style: CustomTextStyle.bodyMedium,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
