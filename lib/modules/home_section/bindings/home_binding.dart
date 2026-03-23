import 'package:get/get.dart';
import 'package:portfolio/core/controllers/app_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController());
  }
}
