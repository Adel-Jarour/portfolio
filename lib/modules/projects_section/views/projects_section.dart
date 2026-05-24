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

    final double horizontalPadding = isMobile
        ? AppSizes.pagePaddingMobile
        : isTablet
            ? AppSizes.pagePaddingTablet
            : AppSizes.pagePaddingDesktop;

    final double viewportWidth = (screenWidth - 2 * horizontalPadding)
        .clamp(0.0, AppSizes.maxContentWidth);

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
                  child: _buildHeaderTitles(isDark),
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
                        image: projects[i].image,
                        isDark: isDark,
                      ),
                    ),
                  );

                  final visibleCount = isMobile ? 1 : (isTablet ? 2 : 3);
                  final double gap = isMobile ? 16.0 : (isTablet ? 20.0 : 24.0);

                  final double cardWidth =
                      (viewportWidth - (visibleCount - 1) * gap) / visibleCount;
                  final int maxIndex = projects.length - visibleCount;

                  final bool showBackBtn = controller.currentIndex.value > 0;
                  final bool showNextBtn =
                      controller.currentIndex.value < maxIndex;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SingleChildScrollView(
                        controller: controller.scrollController,
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            for (int i = 0; i < cards.length; i++) ...[
                              if (i > 0) SizedBox(width: gap),
                              SizedBox(
                                width: cardWidth,
                                child: cards[i],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Back button (shown on any screen size if we are not at the first item)
                      if (maxIndex > 0 && showBackBtn)
                        Positioned(
                          left: -12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _buildNavigationButton(
                              icon: Icons.chevron_left_rounded,
                              onPressed: () =>
                                  controller.scrollBack(cardWidth + gap),
                              isDark: isDark,
                            ),
                          ),
                        ),
                      // Next button (shown on any screen size if we are not at the last item)
                      if (maxIndex > 0 && showNextBtn)
                        Positioned(
                          right: -12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _buildNavigationButton(
                              icon: Icons.chevron_right_rounded,
                              onPressed: () => controller.scrollNext(
                                  cardWidth + gap, maxIndex),
                              isDark: isDark,
                            ),
                          ),
                        ),
                    ],
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
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
