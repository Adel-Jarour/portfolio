import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/modules/contact_section/views/contact_section.dart';
import 'package:portfolio/modules/footer/views/footer_view.dart';
import 'package:portfolio/modules/navbar/views/navbar_view.dart';
import 'package:portfolio/modules/navbar/widgets/nav_drawer.dart';
import 'package:portfolio/modules/home_section/widgets/hero_section.dart';
import 'package:portfolio/modules/about_section/views/about_section.dart';
import 'package:portfolio/modules/projects_section/views/projects_section.dart';
import 'package:portfolio/modules/skills_section/views/skills_section.dart';

class HomeView extends GetView<AppController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      endDrawer: const NavDrawer(),
      floatingActionButton: Obx(() => AnimatedOpacity(
            opacity: controller.showBackToTop.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedSlide(
              offset: controller.showBackToTop.value
                  ? Offset.zero
                  : const Offset(0, 0.5),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: IgnorePointer(
                ignoring: !controller.showBackToTop.value,
                child: FloatingActionButton(
                  onPressed: controller.scrollToTop,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shape: const CircleBorder(),
                  child:
                      const Icon(Icons.keyboard_arrow_up_rounded, size: 28),
                ),
              ),
            ),
          )),
      body: Column(
        children: [
          NavbarView(scaffoldKey: controller.scaffoldKey),
          Expanded(
            child: SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                children: [
                  HeroSection(sectionKey: controller.homeKey),
                  AboutSection(sectionKey: controller.aboutKey),
                  SkillsSection(sectionKey: controller.skillsKey),
                  ProjectsSection(sectionKey: controller.projectsKey),
                  ContactSection(sectionKey: controller.contactKey),
                  const FooterView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
