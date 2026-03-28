import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/localization/strings.dart';

class AppController extends GetxController {
  // Navbar state
  final selectedIndex = 0.obs;
  final isDarkMode = false.obs;
  final showBackToTop = false.obs;

  final navItems = [
    Strings.navHome,
    Strings.navAbout,
    Strings.navSkills,
    Strings.navProjects,
    Strings.navContact,
  ];

  // Section keys for scroll navigation
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final projectsKey = GlobalKey();
  final contactKey = GlobalKey();

  List<GlobalKey> get sectionKeys =>
      [homeKey, aboutKey, skillsKey, projectsKey, contactKey];

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void scrollToSection(int index, ScrollController scrollController) {
    setSelectedIndex(index);
    final key = sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void scrollToTop(ScrollController scrollController) {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    setSelectedIndex(0);
  }
}
