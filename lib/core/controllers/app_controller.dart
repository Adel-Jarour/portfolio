import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/localization/strings.dart';

class AppController extends GetxController {
  // Navbar state
  final selectedIndex = 0.obs;
  final isDarkMode = false.obs;
  final showBackToTop = false.obs;

  // Scroll & scaffold
  final scrollController = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  bool _isProgrammaticScroll = false;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final showBtn = scrollController.offset > 300;
    if (showBtn != showBackToTop.value) {
      showBackToTop.value = showBtn;
    }

    if (!_isProgrammaticScroll) {
      _updateSelectedIndexOnScroll();
    }
  }

  void _updateSelectedIndexOnScroll() {
    if (Get.context == null) return;
    
    final screenHeight = MediaQuery.of(Get.context!).size.height;
    final threshold = screenHeight * 0.35; // Trigger scroll highlights when section is 35% down viewport

    int activeIndex = -1;
    double minDistance = double.infinity;

    for (int i = 0; i < sectionKeys.length; i++) {
      final key = sectionKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final dy = position.dy;
          final height = renderBox.size.height;

          // Check if section is currently active under threshold
          if (dy <= threshold && dy + height > threshold) {
            activeIndex = i;
            break;
          }

          // Fallback closest tracking
          final distance = dy.abs();
          if (distance < minDistance) {
            minDistance = distance;
            activeIndex = i;
          }
        }
      }
    }

    if (activeIndex != -1 && activeIndex != selectedIndex.value) {
      selectedIndex.value = activeIndex;
    }
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void scrollToSection(int index) {
    _isProgrammaticScroll = true;
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
      Future.delayed(const Duration(milliseconds: 650), () {
        _isProgrammaticScroll = false;
      });
    } else {
      _isProgrammaticScroll = false;
    }
  }

  void scrollToTop() {
    _isProgrammaticScroll = true;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    setSelectedIndex(0);
    Future.delayed(const Duration(milliseconds: 650), () {
      _isProgrammaticScroll = false;
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
