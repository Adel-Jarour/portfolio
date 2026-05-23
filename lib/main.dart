import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/firebase_options.dart';
import 'package:portfolio/localization/translations.dart';
import 'package:portfolio/routes/app_pages.dart';
import 'package:portfolio/routes/app_routes.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Log any Flutter framework errors to the browser console
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      print('[FlutterError] ${details.exceptionAsString()}');
    };

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('[main] Firebase initialized successfully');

    Get.put(AppController());
    runApp(const MyApp());
  } catch (e, stack) {
    print('[main] STARTUP CRASH: $e\n$stack');
    // Show a minimal error page instead of a blank screen
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Startup error: $e',
              style: const TextStyle(color: Colors.red)),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Wrap GetMaterialApp in Obx to reactively update theme
    return Obx(() {
      final appController = Get.find<AppController>();
      
      return GetMaterialApp(
        title: 'Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        // ✅ FIX: Sync themeMode with GetX reactive state instead of hardcoded light
        themeMode: appController.isDarkMode.value 
            ? ThemeMode.dark 
            : ThemeMode.light,
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        initialRoute: AppRoutes.home,
        getPages: AppPages.pages,
      );
    });
  }
}
