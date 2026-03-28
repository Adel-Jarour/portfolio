import 'package:get/get.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/modules/about_section/controllers/about_anim_controller.dart';
import 'package:portfolio/modules/contact_section/controllers/contact_anim_controller.dart';
import 'package:portfolio/modules/home_section/controllers/hero_anim_controller.dart';
import 'package:portfolio/modules/projects_section/controllers/projects_anim_controller.dart';
import 'package:portfolio/modules/skills_section/controllers/skills_anim_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController());
    Get.lazyPut<HeroAnimController>(() => HeroAnimController());
    Get.lazyPut<AboutAnimController>(() => AboutAnimController());
    Get.lazyPut<SkillsAnimController>(() => SkillsAnimController());
    Get.lazyPut<ProjectsAnimController>(() => ProjectsAnimController());
    Get.lazyPut<ContactAnimController>(() => ContactAnimController());
  }
}
