import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/controllers/app_controller.dart';
import 'package:portfolio/modules/contact_section/views/contact_section.dart';
import 'package:portfolio/modules/footer/views/footer_view.dart';
import 'package:portfolio/modules/navbar/views/navbar_view.dart';
import 'package:portfolio/modules/navbar/widgets/nav_drawer.dart';
import 'package:portfolio/modules/home_section/widgets/hero_section.dart';
import 'package:portfolio/modules/about_section/views/about_section.dart';
import 'package:portfolio/modules/projects_section/views/projects_section.dart';
import 'package:portfolio/modules/skills_section/views/skills_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ScrollController _scrollController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final AppController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<AppController>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final showBtn = _scrollController.offset > 300;
    if (showBtn != _ctrl.showBackToTop.value) {
      _ctrl.showBackToTop.value = showBtn;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      endDrawer: NavDrawer(scrollController: _scrollController),
      floatingActionButton: Obx(() => AnimatedOpacity(
            opacity: _ctrl.showBackToTop.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedSlide(
              offset: _ctrl.showBackToTop.value
                  ? Offset.zero
                  : const Offset(0, 0.5),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: IgnorePointer(
                ignoring: !_ctrl.showBackToTop.value,
                child: FloatingActionButton(
                  onPressed: () => _ctrl.scrollToTop(_scrollController),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.keyboard_arrow_up_rounded, size: 28),
                ),
              ),
            ),
          )),
      body: Column(
        children: [
          NavbarView(
            scaffoldKey: scaffoldKey,
            scrollController: _scrollController,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HeroSection(sectionKey: _ctrl.homeKey),
                  AboutSection(sectionKey: _ctrl.aboutKey),
                  SkillsSection(sectionKey: _ctrl.skillsKey),
                  ProjectsSection(sectionKey: _ctrl.projectsKey),
                  ContactSection(sectionKey: _ctrl.contactKey),
                  const FooterView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
