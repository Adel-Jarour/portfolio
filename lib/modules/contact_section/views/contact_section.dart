import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:portfolio/widgets/custom_text_field.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;

    return Container(
      width: double.infinity,
      color: AppColors.heroBackground,
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
          child: isMobile || isTablet
              ? _buildMobileLayout(isMobile)
              : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _buildLeftContent(),
        ),
        const SizedBox(width: AppSizes.xxxl),
        Expanded(
          flex: 6,
          child: _buildContactForm(false),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeftContent(),
        const SizedBox(height: AppSizes.xxxl),
        _buildContactForm(isMobile),
      ],
    );
  }

  Widget _buildLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: Strings.contactTitle.tr,
          style: CustomTextStyle.h2,
          fontSize: 42,
          fontWeight: FontWeight.w900,
        ),
        const SizedBox(height: AppSizes.lg),
        CustomText(
          text: Strings.contactSubtitle.tr,
          style: CustomTextStyle.bodyMedium,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
        const SizedBox(height: AppSizes.xxl),
        _buildInfoItem(
          icon: Icons.email_outlined,
          label: Strings.emailMe.tr,
          value: Strings.emailAddress.tr,
        ),
        const SizedBox(height: AppSizes.xl),
        _buildInfoItem(
          icon: Icons.location_on_outlined,
          label: Strings.location.tr,
          value: Strings.locationAddress.tr,
        ),
        const SizedBox(height: AppSizes.xxl),
        Wrap(
          spacing: AppSizes.md,
          runSpacing: AppSizes.md,
          children: [
            CustomButton(
              text: Strings.downloadResume.tr,
              icon: Icons.description_outlined,
              height: 48,
              onPressed: () {},
            ),
            _buildIconButton(Icons.public),
            _buildIconButton(Icons.code),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: AppSizes.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: label,
              style: CustomTextStyle.caption,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: value,
              style: CustomTextStyle.bodyLarge,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: () {},
      ),
    );
  }

  Widget _buildContactForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? AppSizes.xl : AppSizes.xxl),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            CustomTextField(
              labelText: Strings.fullName.tr,
              hintText: Strings.fullNameHint.tr,
            ),
            const SizedBox(height: AppSizes.lg),
            CustomTextField(
              labelText: Strings.emailLabel.tr,
              hintText: Strings.emailHint.tr,
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: Strings.fullName.tr,
                    hintText: Strings.fullNameHint.tr,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: CustomTextField(
                    labelText: Strings.emailLabel.tr,
                    hintText: Strings.emailHint.tr,
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSizes.lg),
          CustomTextField(
            labelText: Strings.subject.tr,
            hintText: Strings.subjectHint.tr,
          ),
          const SizedBox(height: AppSizes.lg),
          CustomTextField(
            labelText: Strings.message.tr,
            hintText: Strings.messageHint.tr,
            maxLines: 4,
          ),
          const SizedBox(height: AppSizes.xl),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: Strings.sendMessage.tr,
              height: 52,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
