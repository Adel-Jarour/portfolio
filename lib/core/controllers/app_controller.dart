import 'package:get/get.dart';
import 'package:portfolio/localization/strings.dart';

class AppController extends GetxController {
  // Navbar state
  final selectedIndex = 0.obs;
  final isDarkMode = false.obs;

  final navItems = [
    Strings.navHome,
    Strings.navAbout,
    Strings.navSkills,
    Strings.navProjects,
    Strings.navContact,
  ];

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
