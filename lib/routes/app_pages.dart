import 'package:get/get.dart';
import 'package:portfolio/modules/home_section/views/home_view.dart';
import 'package:portfolio/modules/home_section/bindings/home_binding.dart';
import 'package:portfolio/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
