import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/custom_text.dart';

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? AppColors.darkCard : AppColors.cardBackground,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppSizes.pagePaddingMobile
            : isTablet
                ? AppSizes.pagePaddingTablet
                : AppSizes.pagePaddingDesktop,
        vertical: AppSizes.xxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Column(
            children: [
              isMobile
                  ? _buildMobileTop(isDark)
                  : _buildDesktopTop(isDark),
              const SizedBox(height: AppSizes.xl),
              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                height: 1,
              ),
              const SizedBox(height: AppSizes.xl),
              CustomText(
                text: Strings.footerCopyright.tr,
                style: CustomTextStyle.bodySmall,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTop(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(isDark),
        _buildLinks(isDark: isDark),
        _buildSocialIcons(isDark),
      ],
    );
  }

  Widget _buildMobileTop(bool isDark) {
    return Column(
      children: [
        _buildLogo(isDark),
        const SizedBox(height: AppSizes.xl),
        _buildLinks(isMobile: true, isDark: isDark),
        const SizedBox(height: AppSizes.xl),
        _buildSocialIcons(isDark),
      ],
    );
  }

  Widget _buildLogo(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: const Center(
            child: CustomText(
              text: '</>',
              style: CustomTextStyle.bodyMedium,
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        CustomText(
          text: 'Portfolio',
          style: CustomTextStyle.h4,
          fontSize: 18,
          color: isDark ? AppColors.darkText : null,
        ),
      ],
    );
  }

  Widget _buildLinks({bool isMobile = false, bool isDark = false}) {
    final links = [
      Strings.privacyPolicy.tr,
      Strings.termsOfService.tr,
      Strings.latestWork.tr,
      Strings.contact.tr,
    ];

    if (isMobile) {
      return Wrap(
        spacing: AppSizes.lg,
        runSpacing: AppSizes.md,
        alignment: WrapAlignment.center,
        children:
            links.map((link) => _buildLinkItem(link, isDark: isDark)).toList(),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        links.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            right: index < links.length - 1 ? AppSizes.xl : 0,
          ),
          child: _buildLinkItem(links[index], isDark: isDark),
        ),
      ),
    );
  }

  Widget _buildLinkItem(String text, {bool isDark = false}) {
    return InkWell(
      onTap: () {},
      child: CustomText(
        text: text,
        style: CustomTextStyle.bodyMedium,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSocialIcons(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(Icons.share_outlined, isDark),
        const SizedBox(width: AppSizes.md),
        _buildIcon(Icons.rss_feed_outlined, isDark),
        const SizedBox(width: AppSizes.md),
        _buildIcon(Icons.star_border_outlined, isDark),
      ],
    );
  }

  Widget _buildIcon(IconData icon, bool isDark) {
    return InkWell(
      onTap: () {},
      child: Icon(
        icon,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        size: 20,
      ),
    );
  }
}
