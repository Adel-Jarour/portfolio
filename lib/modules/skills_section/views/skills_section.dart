import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/skills_section/controllers/skills_controller.dart';
import 'package:portfolio/modules/skills_section/widgets/skill_card.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsSection extends GetView<SkillsController> {
  final Key? sectionKey;
  const SkillsSection({super.key, this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: const Key('skills-section'),
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
          vertical: AppSizes.xxxl + 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────────
                AnimatedFadeSlide(
                  animation: controller.titleCtrl,
                  beginOffset: const Offset(0, 0.08),
                  child: Column(
                    children: [
                      CustomText(
                        text: Strings.skillsTitle.tr,
                        style: CustomTextStyle.h2,
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w800,
                        textAlign: TextAlign.center,
                        color: isDark ? AppColors.darkText : null,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      CustomText(
                        text: Strings.skillsSubtitle.tr,
                        style: CustomTextStyle.bodyMedium,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.xxl + 20),

                // ── Body ────────────────────────────────────────────────────
                Obx(() {
                  if (controller.isLoading.value) {
                    return _buildSkeleton(isMobile, isDark);
                  }
                  if (controller.hasError.value) {
                    return _buildError(isDark);
                  }

                  final grouped = controller.groupedSkills;
                  if (grouped.isEmpty) return const SizedBox.shrink();

                  final entries = grouped.entries.toList();

                  // Build animated SkillCard widgets
                  final cards = List.generate(entries.length, (idx) {
                    final entry = entries[idx];
                    final ctrl = idx < controller.cardCtrls.length
                        ? controller.cardCtrls[idx]
                        : controller.cardCtrls.last;

                    return AnimatedFadeSlide(
                      animation: ctrl,
                      beginOffset: const Offset(0, 0.12),
                      child: SkillCard(
                        icon: _iconForCategory(entry.key),
                        title: entry.key,
                        tags: entry.value.map((s) => s.name).toList(),
                        isDark: isDark,
                      ),
                    );
                  });

                  // Mobile: single column
                  if (isMobile) {
                    return Column(
                      children: List.generate(cards.length, (i) => Padding(
                        padding: EdgeInsets.only(
                            bottom: i < cards.length - 1 ? AppSizes.lg : 0),
                        child: cards[i],
                      )),
                    );
                  }

                  // Tablet: single column of wider cards
                  if (isTablet) {
                    return Column(
                      children: List.generate(cards.length, (i) => Padding(
                        padding: EdgeInsets.only(
                            bottom: i < cards.length - 1 ? AppSizes.xl : 0),
                        child: cards[i],
                      )),
                    );
                  }

                  // Desktop: 2×2 grid
                  return _buildGrid(cards);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Renders cards in a 2-column grid (pairs of rows).
  Widget _buildGrid(List<Widget> cards) {
    final rows = <Widget>[];
    for (int i = 0; i < cards.length; i += 2) {
      final isLastRow = i + 2 >= cards.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: isLastRow ? 0 : AppSizes.xl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[i]),
              const SizedBox(width: AppSizes.xl),
              // If odd number of cards, fill the second slot with empty space
              if (i + 1 < cards.length)
                Expanded(child: cards[i + 1])
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Languages':
        return Icons.code_rounded;
      case 'Libraries & Frameworks':
        return Icons.account_tree_rounded;
      case 'Databases':
        return Icons.storage_rounded;
      case 'Tools & Concepts':
        return Icons.build_rounded;
      default:
        return Icons.star_outline_rounded;
    }
  }

  Widget _buildSkeleton(bool isMobile, bool isDark) {
    if (isMobile) {
      return Column(
        children: List.generate(4, (i) => Padding(
          padding: EdgeInsets.only(bottom: i < 3 ? AppSizes.lg : 0),
          child: _shimmerBox(isDark, height: 200),
        )),
      );
    }
    // 2×2 skeleton
    return Column(
      children: [
        Row(children: [
          Expanded(child: _shimmerBox(isDark, height: 220)),
          const SizedBox(width: AppSizes.xl),
          Expanded(child: _shimmerBox(isDark, height: 220)),
        ]),
        const SizedBox(height: AppSizes.xl),
        Row(children: [
          Expanded(child: _shimmerBox(isDark, height: 220)),
          const SizedBox(width: AppSizes.xl),
          Expanded(child: _shimmerBox(isDark, height: 220)),
        ]),
      ],
    );
  }

  Widget _shimmerBox(bool isDark, {required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
    );
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
            text: 'Could not load skills. Check your connection.',
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
