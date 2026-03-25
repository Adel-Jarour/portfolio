import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/widgets/custom_text.dart';

class NavDrawer extends GetView<AppController> {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Row(
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
                        style: CustomTextStyle.bodyMedium,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  CustomText(
                    text: Strings.portfolio.tr,
                    style: CustomTextStyle.h4,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            const SizedBox(height: AppSizes.md),

            // Nav items
            ...List.generate(controller.navItems.length, (index) {
              return Obx(() {
                final isSelected = controller.selectedIndex.value == index;
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                  title: CustomText(
                    text: controller.navItems[index].tr,
                    style: CustomTextStyle.navLink,
                    color:
                        isSelected ? AppColors.primary : AppColors.navLinkText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 16,
                  ),
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  onTap: () {
                    controller.setSelectedIndex(index);
                    Navigator.of(context).pop();
                  },
                );
              });
            }),

            const Spacer(),

            // Hire Me button
            Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: Strings.hireMe.tr,
                  variant: CustomButtonVariant.filled,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
