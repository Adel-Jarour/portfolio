import 'package:get/get.dart';

class AppController extends GetxController {
  // Navbar state
  final selectedIndex = 0.obs;
  final isDarkMode = false.obs;

  final navItems = [
    'nav_home',
    'nav_about',
    'nav_skills',
    'nav_projects',
    'nav_contact',
  ];

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
