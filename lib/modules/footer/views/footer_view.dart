import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:portfolio/core/controllers/app_controller.dart';

class FooterView extends GetView<AppController> {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // We use the dark Card color for the footer background to match the "dark" aesthetic
    // of the image, even if we are in light mode, or adapt it if user wants light mode footer.
    // The image specifically shows a very dark footer. Let's make it adapt to the theme as requested.
    final bgColor = isDark ? AppColors.darkCard : AppColors.cardBackground;
    final textColorPrimary =
        isDark ? AppColors.darkText : AppColors.textPrimary;
    final textColorSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      children: [
        // Top Gradient Line
        Container(
          height: 2,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark,
                AppColors.primaryLight,
              ],
            ),
          ),
        ),
        // Main Footer Content
        Container(
          width: double.infinity,
          color: bgColor,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? AppSizes.pagePaddingMobile
                : isTablet
                    ? AppSizes.pagePaddingTablet
                    : AppSizes.pagePaddingDesktop,
            vertical: AppSizes.xxxl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
              child: Column(
                children: [
                  // Top Section (3 Columns on Desktop, 1 on Mobile/Tablet)
                  if (isMobile || isTablet)
                    _buildMobileContent(
                        textColorPrimary, textColorSecondary, isDark, isMobile)
                  else
                    _buildDesktopContent(
                        textColorPrimary, textColorSecondary, isDark),

                  const SizedBox(height: AppSizes.xxxl),

                  // Divider
                  Divider(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    height: 1,
                  ),

                  const SizedBox(height: AppSizes.xl),

                  // Bottom Section
                  if (isMobile)
                    _buildBottomMobile(textColorSecondary, isDark)
                  else
                    _buildBottomDesktop(textColorSecondary, isDark),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopContent(
      Color textColorPrimary, Color textColorSecondary, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 4,
            child:
                _buildLeftColumn(textColorPrimary, textColorSecondary, isDark)),
        const SizedBox(width: AppSizes.xl),
        Expanded(
            flex: 3,
            child: _buildMiddleColumn(
                textColorPrimary, textColorSecondary, isDark)),
        const SizedBox(width: AppSizes.xl),
        Expanded(
            flex: 4,
            child: _buildRightColumn(
                textColorPrimary, textColorSecondary, isDark)),
      ],
    );
  }

  Widget _buildMobileContent(Color textColorPrimary, Color textColorSecondary,
      bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeftColumn(textColorPrimary, textColorSecondary, isDark),
        const SizedBox(height: AppSizes.xxl),
        _buildMiddleColumn(textColorPrimary, textColorSecondary, isDark),
        const SizedBox(height: AppSizes.xxl),
        _buildRightColumn(textColorPrimary, textColorSecondary, isDark),
      ],
    );
  }

  // ─── Left Column: Brand & Badges ──────────────────────────────────────────
  Widget _buildLeftColumn(
      Color textColorPrimary, Color textColorSecondary, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and Name
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Center(
                child: CustomText(
                  text: '</>',
                  style: CustomTextStyle.h4,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: Strings.footerName.tr,
                  style: CustomTextStyle.h3,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColorPrimary,
                ),
                CustomText(
                  text: Strings.footerTitle.tr,
                  style: CustomTextStyle.bodyMedium,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),

        // Description
        CustomText(
          text: Strings.footerDesc.tr,
          style: CustomTextStyle.bodyMedium,
          color: textColorSecondary,
          height: 1.6,
        ),
        const SizedBox(height: AppSizes.xl),

        // Badges
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: [
            _buildBadgeItem('Flutter', Icons.flutter_dash, isDark),
            _buildBadgeItem('Dart', Icons.code, isDark),
            _buildBadgeItem('GetX', Icons.bolt, isDark),
            _buildBadgeItem(Strings.badgeResponsive.tr, Icons.devices, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgeItem(String text, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF13132A)
            : AppColors.badgeBg, // Slightly darker than card
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: isDark ? AppColors.darkBorderLight : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isDark ? AppColors.primaryLight : AppColors.primary),
          const SizedBox(width: 6),
          CustomText(
            text: text,
            style: CustomTextStyle.caption,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  // ─── Middle Column: Links & Socials ─────────────────────────────────────
  Widget _buildMiddleColumn(
      Color textColorPrimary, Color textColorSecondary, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: Strings.quickLinks.tr,
          style: CustomTextStyle.h4,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textColorPrimary,
        ),
        const SizedBox(height: AppSizes.lg),
        _buildLinkItem(Strings.navHome.tr, Icons.home_outlined,
            () => controller.scrollToSection(0), textColorSecondary),
        _buildLinkItem(Strings.navAbout.tr, Icons.person_outline,
            () => controller.scrollToSection(1), textColorSecondary),
        _buildLinkItem(Strings.navProjects.tr, Icons.folder_outlined,
            () => controller.scrollToSection(3), textColorSecondary),
        _buildLinkItem(Strings.navContact.tr, Icons.email_outlined,
            () => controller.scrollToSection(4), textColorSecondary),
      ],
    );
  }

  Widget _buildLinkItem(
      String text, IconData icon, VoidCallback onTap, Color textColor) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.md),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: AppSizes.sm),
            CustomText(
              text: text,
              style: CustomTextStyle.bodyMedium,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Right Column: Contact CTA ──────────────────────────────────────────
  Widget _buildRightColumn(
      Color textColorPrimary, Color textColorSecondary, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.footerBuildTogether1.tr,
                style: AppTextStyles.h3.copyWith(
                    color: textColorPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: Strings.footerBuildTogether2.tr,
                style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        CustomText(
          text: Strings.footerBuildTogetherDesc.tr,
          style: CustomTextStyle.bodyMedium,
          color: textColorSecondary,
          height: 1.6,
        ),
        const SizedBox(height: AppSizes.xl),
        InkWell(
          onTap: () => controller.scrollToSection(4),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xl, vertical: AppSizes.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                const SizedBox(width: AppSizes.sm),
                CustomText(
                  text: Strings.contactMe.tr,
                  style: CustomTextStyle.button,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Bottom Rows ────────────────────────────────────────────────────────
  Widget _buildBottomDesktop(Color textColorSecondary, bool isDark) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: Strings.footerCopy.tr,
          style: CustomTextStyle.caption,
          color: textColorSecondary,
        ),
        Row(
          children: [
            Icon(Icons.star, color: AppColors.primary, size: 14),
            const SizedBox(width: 8),
            CustomText(
              text: Strings.footerBuiltWith.tr,
              style: CustomTextStyle.caption,
              color: textColorSecondary,
            ),
          ],
        ),
        Row(children: [
          CustomText(
            text: Strings.footerDesignedCodedWith1.tr,
            style: CustomTextStyle.caption,
            color: textColorSecondary,
          ),
          const Icon(Icons.favorite, color: Colors.blue, size: 14),
          CustomText(
            text: Strings.footerDesignedCodedWith2.tr,
            style: CustomTextStyle.caption,
            color: textColorSecondary,
          ),
        ])
      ],
    );
  }

  Widget _buildBottomMobile(Color textColorSecondary, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: AppColors.primary, size: 14),
            const SizedBox(width: 8),
            CustomText(
              text: Strings.footerBuiltWith.tr,
              style: CustomTextStyle.caption,
              color: textColorSecondary,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomText(
            text: Strings.footerDesignedCodedWith1.tr,
            style: CustomTextStyle.caption,
            color: textColorSecondary,
          ),
          const Icon(Icons.favorite, color: Colors.blue, size: 14),
          CustomText(
            text: Strings.footerDesignedCodedWith2.tr,
            style: CustomTextStyle.caption,
            color: textColorSecondary,
          ),
        ]),
        const SizedBox(height: AppSizes.lg),
        CustomText(
          text: Strings.footerCopy.tr,
          style: CustomTextStyle.caption,
          color: textColorSecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
