import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/skills_section/widgets/skill_card.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsSection extends StatefulWidget {
  final Key? sectionKey;
  const SkillsSection({super.key, this.sectionKey});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _titleCtrl;
  late List<AnimationController> _cardCtrls;
  bool _animated = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardCtrls = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    for (final c in _cardCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      _titleCtrl.forward();
      for (int i = 0; i < _cardCtrls.length; i++) {
        Future.delayed(Duration(milliseconds: 200 + i * 150), () {
          if (mounted) _cardCtrls[i].forward();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cards = [
      SkillCard(
        icon: Icons.code,
        title: Strings.skillFrontend.tr,
        isDark: isDark,
        tags: const [
          'React.js',
          'Next.js',
          'TailwindCSS',
          'TypeScript',
          'Framer Motion',
        ],
      ),
      SkillCard(
        icon: Icons.storage_rounded,
        title: Strings.skillBackend.tr,
        isDark: isDark,
        tags: const [
          'Node.js',
          'PostgreSQL',
          'GraphQL',
          'Firebase',
          'Prisma',
        ],
      ),
      SkillCard(
        icon: Icons.draw_outlined,
        title: Strings.skillDesign.tr,
        isDark: isDark,
        tags: const [
          'Figma',
          'UI/UX Design',
          'Prototyping',
          'Adobe CC',
          'Design Systems',
        ],
      ),
    ];

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: _onVisibility,
      child: Container(
        key: widget.sectionKey,
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
          child: Column(
            children: [
              AnimatedFadeSlide(
                animation: _titleCtrl,
                beginOffset: const Offset(0, 0.08),
                child: Column(
                  children: [
                    CustomText(
                      text: Strings.skillsTitle.tr,
                      style: CustomTextStyle.h2,
                      fontSize: isMobile ? 32 : 40,
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
              if (isMobile)
                Column(
                  children: List.generate(
                    cards.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index < cards.length - 1 ? AppSizes.lg : 0,
                      ),
                      child: AnimatedFadeSlide(
                        animation: _cardCtrls[index],
                        beginOffset: const Offset(0, 0.12),
                        child: cards[index],
                      ),
                    ),
                  ),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    cards.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index < cards.length - 1 ? AppSizes.xl : 0,
                        ),
                        child: AnimatedFadeSlide(
                          animation: _cardCtrls[index],
                          beginOffset: const Offset(0, 0.12),
                          child: cards[index],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
