import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:portfolio/widgets/custom_text_field.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactSection extends StatefulWidget {
  final Key? sectionKey;
  const ContactSection({super.key, this.sectionKey});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _animated = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: _onVisibility,
      child: Container(
        key: widget.sectionKey,
        width: double.infinity,
        color: isDark ? AppColors.darkHero : AppColors.heroBackground,
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
            child: isMobile || isTablet
                ? _buildMobileLayout(isMobile, isDark)
                : _buildDesktopLayout(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: AnimatedFadeSlide(
            animation: _ctrl,
            beginOffset: const Offset(-0.12, 0),
            child: _buildLeftContent(isDark),
          ),
        ),
        const SizedBox(width: AppSizes.xxxl),
        Expanded(
          flex: 6,
          child: AnimatedFadeSlide(
            animation: _ctrl,
            beginOffset: const Offset(0.12, 0),
            child: _buildContactForm(false, isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedFadeSlide(
          animation: _ctrl,
          beginOffset: const Offset(-0.1, 0),
          child: _buildLeftContent(isDark),
        ),
        const SizedBox(height: AppSizes.xxxl),
        AnimatedFadeSlide(
          animation: _ctrl,
          beginOffset: const Offset(0.1, 0),
          child: _buildContactForm(isMobile, isDark),
        ),
      ],
    );
  }

  Widget _buildLeftContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: Strings.contactTitle.tr,
          style: CustomTextStyle.h2,
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: isDark ? AppColors.darkText : null,
        ),
        const SizedBox(height: AppSizes.lg),
        CustomText(
          text: Strings.contactSubtitle.tr,
          style: CustomTextStyle.bodyMedium,
          color:
              isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          height: 1.6,
        ),
        const SizedBox(height: AppSizes.xxl),
        _buildInfoItem(
          icon: Icons.email_outlined,
          label: Strings.emailMe.tr,
          value: Strings.emailAddress.tr,
          isDark: isDark,
        ),
        const SizedBox(height: AppSizes.xl),
        _buildInfoItem(
          icon: Icons.location_on_outlined,
          label: Strings.location.tr,
          value: Strings.locationAddress.tr,
          isDark: isDark,
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
            _buildIconButton(Icons.public, isDark),
            _buildIconButton(Icons.code, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
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
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: value,
              style: CustomTextStyle.bodyLarge,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: () {},
      ),
    );
  }

  Widget _buildContactForm(bool isMobile, bool isDark) {
    return Container(
      padding: EdgeInsets.all(isMobile ? AppSizes.xl : AppSizes.xxl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
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
