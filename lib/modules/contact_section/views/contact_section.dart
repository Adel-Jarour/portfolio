import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/contact_section/controllers/contact_anim_controller.dart';
import 'package:portfolio/widgets/animated_fade_slide.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:portfolio/widgets/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactSection extends GetView<ContactAnimController> {
  final Key? sectionKey;
  const ContactSection({super.key, this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
    final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: controller.onVisibility,
      child: Container(
        key: sectionKey,
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
            animation: controller.animCtrl,
            beginOffset: const Offset(-0.12, 0),
            child: _buildLeftContent(isDark),
          ),
        ),
        const SizedBox(width: AppSizes.xxxl),
        Expanded(
          flex: 6,
          child: AnimatedFadeSlide(
            animation: controller.animCtrl,
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
          animation: controller.animCtrl,
          beginOffset: const Offset(-0.1, 0),
          child: _buildLeftContent(isDark),
        ),
        const SizedBox(height: AppSizes.xxxl),
        AnimatedFadeSlide(
          animation: controller.animCtrl,
          beginOffset: const Offset(0.1, 0),
          child: _buildContactForm(isMobile, isDark),
        ),
      ],
    );
  }

  Widget _buildLeftContent(bool isDark) {
    return Obx(() {
      final info = controller.portfolioInfo.value;
      final email = info?.email.isNotEmpty == true
          ? info!.email
          : Strings.emailAddress.tr;
      final location = info?.location.isNotEmpty == true
          ? info!.location
          : Strings.locationAddress.tr;

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
            value: email,
            isDark: isDark,
          ),
          const SizedBox(height: AppSizes.xl),
          _buildInfoItem(
            icon: Icons.location_on_outlined,
            label: Strings.location.tr,
            value: location,
            isDark: isDark,
          ),
          const SizedBox(height: AppSizes.xxl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomButton(
                text: Strings.downloadResume.tr,
                width: 250,
                icon: Icons.description_outlined,
                height: 48,
                onPressed: () async {
                  final Uri cvUrl = Uri.parse(
                      'https://drive.google.com/uc?export=download&id=1AOpj4vGfNJmmaS0r3TtDzbtRsMuntQhL');

                  if (await canLaunchUrl(cvUrl)) {
                    await launchUrl(cvUrl);
                  } else {
                    print('Could not launch $cvUrl');
                  }
                },
              ),
              SizedBox(
                height: AppSizes.md,
              ),
              Row(
                children: [
                  _buildIconButton('assets/icons/linkedin.png', isDark,
                      onTap: () {
                    final url = info?.linkedin;
                    if (url != null && url.isNotEmpty) {
                      _launchUrl(url);
                    }
                  }),
                  SizedBox(
                    width: AppSizes.md,
                  ),
                  _buildIconButton('assets/icons/github.png', isDark,
                      onTap: () {
                    final url = info?.github;
                    if (url != null && url.isNotEmpty) {
                      _launchUrl(url);
                    }
                  }),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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

  Widget _buildIconButton(String icon, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: isDark ? AppColors.darkBorderLight : AppColors.borderLight,
            )),
        alignment: Alignment.center,
        padding: EdgeInsetsDirectional.all(5),
        child: Image.asset(
          icon,
          color: Colors.white,
          fit: BoxFit.contain,
        ),
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
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              CustomTextField(
                controller: controller.nameController,
                labelText: Strings.fullName.tr,
                hintText: Strings.fullNameHint.tr,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? Strings.errorNameRequired.tr
                    : null,
              ),
              const SizedBox(height: AppSizes.lg),
              CustomTextField(
                controller: controller.emailController,
                labelText: Strings.emailLabel.tr,
                hintText: Strings.emailHint.tr,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return Strings.errorEmailRequired.tr;
                  }
                  if (!GetUtils.isEmail(value.trim())) {
                    return Strings.errorEmailInvalid.tr;
                  }
                  return null;
                },
              ),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.nameController,
                      labelText: Strings.fullName.tr,
                      hintText: Strings.fullNameHint.tr,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? Strings.errorNameRequired.tr
                              : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: CustomTextField(
                      controller: controller.emailController,
                      labelText: Strings.emailLabel.tr,
                      hintText: Strings.emailHint.tr,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Strings.errorEmailRequired.tr;
                        }
                        if (!GetUtils.isEmail(value.trim())) {
                          return Strings.errorEmailInvalid.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: AppSizes.lg),
            CustomTextField(
              controller: controller.subjectController,
              labelText: Strings.subject.tr,
              hintText: Strings.subjectHint.tr,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? Strings.errorSubjectRequired.tr
                  : null,
            ),
            const SizedBox(height: AppSizes.lg),
            CustomTextField(
              controller: controller.messageController,
              labelText: Strings.message.tr,
              hintText: Strings.messageHint.tr,
              maxLines: 4,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? Strings.errorMessageRequired.tr
                  : null,
            ),
            const SizedBox(height: AppSizes.xl),
            SizedBox(
              width: double.infinity,
              child: Obx(() => CustomButton(
                    text: Strings.sendMessage.tr,
                    height: 52,
                    isLoading: controller.isSending.value,
                    onPressed: controller.sendEmail,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
