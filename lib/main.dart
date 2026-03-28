import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/localization/translations.dart';
import 'package:portfolio/routes/app_pages.dart';
import 'package:portfolio/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (ctrl) => GetMaterialApp(
        title: 'Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ctrl.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        initialRoute: AppRoutes.home,
        getPages: AppPages.pages,
      ),
    );
  }
}

