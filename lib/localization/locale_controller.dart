import 'dart:ui';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  var currentLocale = const Locale('en', 'US');

  void changeLocale(String languageCode, String countryCode) {
    currentLocale = Locale(languageCode, countryCode);
    Get.updateLocale(currentLocale);
  }

  void toggleLocale() {
    if (currentLocale.languageCode == 'en') {
      changeLocale('ar', 'SA');
    } else {
      changeLocale('en', 'US');
    }
  }
}
