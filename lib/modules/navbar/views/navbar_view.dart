import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/navbar/widgets/nav_link_item.dart';
import 'package:portfolio/widgets/custom_text.dart';

class NavbarView extends GetView<AppController> implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavbarView({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.navbarHeight);

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= AppSizes.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppSizes.navbarHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavbar : AppColors.navbarBg,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal:
            isMobile ? AppSizes.pagePaddingMobile : AppSizes.pagePaddingDesktop,
      ),
      child: Row(
        children: [
          _buildLogo(isDark),
          const Spacer(),
          if (isMobile)
            IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
              onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
            )
          else ...[
            Obx(
              () => Row(
                children: List.generate(controller.navItems.length, (index) {
                  return NavLinkItem(
                    title: controller.navItems[index],
                    isSelected: controller.selectedIndex.value == index,
                    onTap: () => controller.scrollToSection(index),
                  );
                }),
              ),
            ),
            const SizedBox(width: AppSizes.lg),
            IconButton(
              onPressed: controller.toggleTheme,
              icon: Obx(
                () => Icon(
                  controller.isDarkMode.value
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: isDark ? AppColors.darkText : AppColors.navLinkText,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            CustomButton(
              text: Strings.hireMe.tr,
              variant: CustomButtonVariant.filled,
              onPressed: () {
                controller.scrollToSection(4);
              },
            ),
          ],
        ],
      ),
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
}
