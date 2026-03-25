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

    return Container(
      width: double.infinity,
      color: AppColors.cardBackground,
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
              isMobile ? _buildMobileTop() : _buildDesktopTop(),
              const SizedBox(height: AppSizes.xl),
              const Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: AppSizes.xl),
              CustomText(
                text: Strings.footerCopyright.tr,
                style: CustomTextStyle.bodySmall,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(),
        _buildLinks(),
        _buildSocialIcons(),
      ],
    );
  }

  Widget _buildMobileTop() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: AppSizes.xl),
        _buildLinks(isMobile: true),
        const SizedBox(height: AppSizes.xl),
        _buildSocialIcons(),
      ],
    );
  }

  Widget _buildLogo() {
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
        const CustomText(
          text: 'Portfolio',
          style: CustomTextStyle.h4,
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _buildLinks({bool isMobile = false}) {
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
        children: links.map((link) => _buildLinkItem(link)).toList(),
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
          child: _buildLinkItem(links[index]),
        ),
      ),
    );
  }

  Widget _buildLinkItem(String text) {
    return InkWell(
      onTap: () {},
      child: CustomText(
        text: text,
        style: CustomTextStyle.bodyMedium,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(Icons.share_outlined),
        const SizedBox(width: AppSizes.md),
        _buildIcon(Icons.rss_feed_outlined),
        const SizedBox(width: AppSizes.md),
        _buildIcon(Icons.star_border_outlined),
      ],
    );
  }

  Widget _buildIcon(IconData icon) {
    return InkWell(
      onTap: () {},
      child: Icon(
        icon,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }
}
