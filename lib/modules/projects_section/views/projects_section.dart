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

  /// How much of the next (peeking) card is visible, as a fraction of card width.
  static const double _peekFraction = 0.15;

  /// Scale of a card that is only peeking at the edge.
  static const double _peekScale = 0.92;

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

                  // Number of fully-visible cards (not counting the peek).
                  final int fullVisible = isMobile ? 1 : 2;
                  final double gap =
                      isMobile ? 16.0 : (isTablet ? 20.0 : 24.0);

                  // Card width: the viewport must fit `fullVisible` cards +
                  // gaps between them + a peek portion of the next card.
                  // viewportWidth = fullVisible * cardWidth
                  //               + (fullVisible - 1) * gap
                  //               + gap              (gap before peek card)
                  //               + peekFraction * cardWidth
                  //
                  // => cardWidth = (viewportWidth - fullVisible * gap)
                  //              / (fullVisible + peekFraction)
                  final double cardWidth =
                      (viewportWidth - fullVisible * gap) /
                          (fullVisible + _peekFraction);

                  final double itemStep = cardWidth + gap;
                  final int maxIndex =
                      (projects.length - fullVisible).clamp(0, projects.length);

                  final bool showBackBtn = controller.currentIndex.value > 0;
                  final bool showNextBtn =
                      controller.currentIndex.value < maxIndex;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ── Scrollable card strip ───────────────────────────
                      NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          // Trigger rebuild so AnimatedBuilder below picks up
                          // the new scroll offset.
                          if (notification is ScrollUpdateNotification) {
                            controller.scrollNotifier.value =
                                controller.scrollController.offset;
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          physics: const BouncingScrollPhysics(),
                          child: ValueListenableBuilder<double>(
                            valueListenable: controller.scrollNotifier,
                            builder: (context, scrollOffset, _) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (int i = 0;
                                      i < projects.length;
                                      i++) ...[
                                    if (i > 0) SizedBox(width: gap),
                                    _buildScaledCard(
                                      index: i,
                                      cardWidth: cardWidth,
                                      itemStep: itemStep,
                                      scrollOffset: scrollOffset,
                                      fullVisible: fullVisible,
                                      animation: i < animations.length
                                          ? animations[i]
                                          : animations.last,
                                      project: projects[i],
                                      isDark: isDark,
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      // ── Back button ─────────────────────────────────────
                      if (maxIndex > 0 && showBackBtn)
                        Positioned(
                          left: -12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _buildNavigationButton(
                              icon: Icons.chevron_left_rounded,
                              onPressed: () =>
                                  controller.scrollBack(itemStep),
                              isDark: isDark,
                            ),
                          ),
                        ),

                      // ── Next button ─────────────────────────────────────
                      if (maxIndex > 0 && showNextBtn)
                        Positioned(
                          right: -12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _buildNavigationButton(
                              icon: Icons.chevron_right_rounded,
                              onPressed: () =>
                                  controller.scrollNext(itemStep, maxIndex),
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

  // ── Scaled card builder ────────────────────────────────────────────────────

  Widget _buildScaledCard({
    required int index,
    required double cardWidth,
    required double itemStep,
    required double scrollOffset,
    required int fullVisible,
    required AnimationController animation,
    required dynamic project,
    required bool isDark,
  }) {
    // Position of this card's left edge relative to the scroll offset.
    final double cardStart = index * itemStep;

    // How far past the last fully-visible slot is this card?
    // visibleEnd = scrollOffset + fullVisible * itemStep
    final double visibleEnd = scrollOffset + fullVisible * itemStep;

    // A card is "fully in view" when its left edge < visibleEnd - itemStep
    // (i.e. it's within the first `fullVisible` slots from scroll position).
    // We calculate a 0→1 "overflow" ratio for the peek effect:
    //   0 = fully in view, 1 = completely past the visible region.
    double overflow = 0.0;
    if (cardStart >= visibleEnd - itemStep) {
      // Card is in the peek zone or beyond
      overflow =
          ((cardStart - (visibleEnd - itemStep)) / itemStep).clamp(0.0, 1.0);
    }
    // Also handle cards that have scrolled off to the left
    if (cardStart < scrollOffset - itemStep * 0.1) {
      final double leftOverflow =
          ((scrollOffset - cardStart) / itemStep).clamp(0.0, 1.0);
      overflow = leftOverflow;
    }

    final double scale =
        1.0 - overflow * (1.0 - _peekScale); // 1.0 → _peekScale

    return SizedBox(
      width: cardWidth,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale),
        child: AnimatedFadeSlide(
          animation: animation,
          beginOffset: const Offset(0, 0.12),
          child: ProjectCard(
            key: ValueKey(project.id),
            title: project.name,
            category: project.status,
            year: '',
            description: project.description,
            technologies: const [],
            codeUrl: project.code,
            image: project.image,
            isDark: isDark,
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

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

  // ── Skeleton ───────────────────────────────────────────────────────────────

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

  // ── Error ──────────────────────────────────────────────────────────────────

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

  // ── Navigation button ──────────────────────────────────────────────────────

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
