import 'package:get/get.dart';
import 'package:portfolio/modules/about_section/controllers/about_controller.dart';
import 'package:portfolio/modules/contact_section/controllers/contact_anim_controller.dart';
import 'package:portfolio/modules/home_section/controllers/hero_anim_controller.dart';
import 'package:portfolio/modules/projects_section/controllers/projects_controller.dart';
import 'package:portfolio/modules/skills_section/controllers/skills_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // AppController is already registered in main()
    Get.lazyPut<HeroAnimController>(() => HeroAnimController());
    Get.lazyPut<AboutController>(() => AboutController());
    Get.lazyPut<SkillsController>(() => SkillsController());
    Get.lazyPut<ProjectsController>(() => ProjectsController());
    Get.lazyPut<ContactAnimController>(() => ContactAnimController());
  }
}
