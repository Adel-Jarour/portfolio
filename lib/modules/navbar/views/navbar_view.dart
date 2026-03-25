import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:portfolio/modules/navbar/widgets/nav_link_item.dart';

class NavbarView extends GetView<AppController> implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavbarView({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.navbarHeight);

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= AppSizes.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      height: AppSizes.navbarHeight,
      decoration: BoxDecoration(
        color: AppColors.navbarBg,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal:
            isMobile ? AppSizes.pagePaddingMobile : AppSizes.pagePaddingDesktop,
      ),
      child: Row(
        children: [
          _buildLogo(),
          const Spacer(),
          if (isMobile)
            IconButton(
              icon:
                  const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
              onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
            )
          else ...[
            Obx(
              () => Row(
                children: List.generate(controller.navItems.length, (index) {
                  return NavLinkItem(
                    title: controller.navItems[index],
                    isSelected: controller.selectedIndex.value == index,
                    onTap: () => controller.setSelectedIndex(index),
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
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: AppColors.navLinkText,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            CustomButton(
              text: Strings.hireMe.tr,
              variant: CustomButtonVariant.filled,
              onPressed: () {},
            ),
          ],
        ],
      ),
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
            child: Text(
              '</>',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Text(
          'Portfolio',
          style: AppTextStyles.h4.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
