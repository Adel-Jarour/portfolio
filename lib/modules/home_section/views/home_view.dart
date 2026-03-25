import 'package:flutter/material.dart';
import 'package:portfolio/modules/contact_section/views/contact_section.dart';
import 'package:portfolio/modules/footer/views/footer_view.dart';
import 'package:portfolio/modules/navbar/views/navbar_view.dart';
import 'package:portfolio/modules/navbar/widgets/nav_drawer.dart';
import 'package:portfolio/modules/home_section/widgets/hero_section.dart';
import 'package:portfolio/modules/about_section/views/about_section.dart';
import 'package:portfolio/modules/projects_section/views/projects_section.dart';
import 'package:portfolio/modules/skills_section/views/skills_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const NavDrawer(),
      body: Column(
        children: [
          NavbarView(scaffoldKey: scaffoldKey),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  HeroSection(),
                  AboutSection(),
                  SkillsSection(),
                  ProjectsSection(),
                  ContactSection(),
                  FooterView(),
                  // Future sections will be added here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
