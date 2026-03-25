import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/skills_section/widgets/skill_card.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;

    final cards = [
      SkillCard(
        icon: Icons.code,
        title: Strings.skillFrontend.tr,
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
        tags: const [
          'Figma',
          'UI/UX Design',
          'Prototyping',
          'Adobe CC',
          'Design Systems',
        ],
      ),
    ];
    return Container(
      width: double.infinity,
      color: AppColors.background,
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
            Column(
              children: [
                Text(
                  Strings.skillsTitle.tr,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: isMobile ? 32 : 40,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  Strings.skillsSubtitle.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
                    child: cards[index],
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
                      child: cards[index],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
