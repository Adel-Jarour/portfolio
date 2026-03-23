import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/widgets/custom_text.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppSizes.pagePaddingMobile
            : isTablet
                ? AppSizes.pagePaddingTablet
                : AppSizes.pagePaddingDesktop,
        vertical: isMobile ? AppSizes.xxl : AppSizes.xxxl + 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: isMobile || isTablet
              ? _buildMobileLayout(context, isMobile)
              : _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: _buildTextContent(context, false),
        ),
        const SizedBox(width: AppSizes.xxl),
        Expanded(
          flex: 5,
          child: _buildProfileImage(context, false),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isMobile) {
    return Column(
      children: [
        _buildTextContent(context, true),
        const SizedBox(height: AppSizes.xl),
        _buildProfileImage(context, true),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.badgeBg,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: CustomText(
            text: 'available_for_projects'.tr,
            style: CustomTextStyle.caption,
            color: AppColors.badgeText,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSizes.lg),

        // Heading
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'hero_title_1'.tr,
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 36 : 52,
                ),
              ),
              TextSpan(
                text: 'hero_title_highlight'.tr,
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 36 : 52,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: 'hero_title_2'.tr,
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 36 : 52,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.lg),

        // Subtitle
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 420,
          ),
          child: CustomText(
            text: 'hero_subtitle'.tr,
            style: CustomTextStyle.bodyMedium,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
        const SizedBox(height: AppSizes.xl),

        // Buttons – Row side by side, intrinsic width
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            CustomButton(
              text: 'hire_me'.tr,
              variant: CustomButtonVariant.filled,
              onPressed: () {},
            ),
            const SizedBox(width: AppSizes.md),
            CustomButton(
              text: 'view_portfolio'.tr,
              variant: CustomButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context, bool isMobile) {
    final imageSize = isMobile ? 280.0 : 420.0;

    return Center(
      child: Container(
        width: imageSize,
        height: imageSize + 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5E6DA),
              Color(0xFFEED9CC),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                child: Image.asset(
                  'assets/images/profile_photo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
              child: Text(
                'professional_profile'.tr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
