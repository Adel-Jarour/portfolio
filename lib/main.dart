import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/localization/translations.dart';
import 'package:portfolio/routes/app_pages.dart';
import 'package:portfolio/routes/app_routes.dart';

void main() {
  // Pre-register AppController so it's available before GetMaterialApp builds
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
