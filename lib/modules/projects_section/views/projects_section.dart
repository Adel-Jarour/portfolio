import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/projects_section/widgets/project_card.dart';
import 'package:portfolio/widgets/custom_text.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;

    return Container(
      width: double.infinity,
      color: AppColors.cardBackground, // requested light mode background
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
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderTitles(),
                    const SizedBox(height: AppSizes.lg),
                    _buildViewArchiveBtn(),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildHeaderTitles(),
                    _buildViewArchiveBtn(),
                  ],
                ),
              
              const SizedBox(height: AppSizes.xxl),

              // Cards
              if (isMobile || isTablet)
                Column(
                  children: [
                    _buildCard1(),
                    const SizedBox(height: AppSizes.xl),
                    _buildCard2(),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(child: _buildCard1()),
                    const SizedBox(width: AppSizes.xxl),
                    Expanded(child: _buildCard2()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: Strings.selectedWorks.tr,
          style: CustomTextStyle.h2,
        ),
        const SizedBox(height: AppSizes.sm),
        CustomText(
          text: Strings.selectedWorksSubtitle.tr,
          style: CustomTextStyle.bodyMedium,
          color: AppColors.textSecondary,
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

  Widget _buildCard1() {
    return ProjectCard(
      imageUrl: '', // placeholder
      category: Strings.project1Category.tr,
      year: Strings.project1Year.tr,
      title: Strings.project1Title.tr,
      description: Strings.project1Desc.tr,
      technologies: const ['React', 'D3.js', 'Supabase'],
    );
  }

  Widget _buildCard2() {
    return ProjectCard(
      imageUrl: '', // placeholder
      category: Strings.project2Category.tr,
      year: Strings.project2Year.tr,
      title: Strings.project2Title.tr,
      description: Strings.project2Desc.tr,
      technologies: const ['Next.js', 'Shopify', 'Stripe'],
    );
  }
}
