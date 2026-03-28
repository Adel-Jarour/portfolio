import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsAnimController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController headerCtrl;
  late AnimationController card1Ctrl;
  late AnimationController card2Ctrl;
  bool _animated = false;

  @override
  void onInit() {
    super.onInit();
    headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    card1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    card2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      headerCtrl.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        card1Ctrl.forward();
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        card2Ctrl.forward();
      });
    }
  }

  @override
  void onClose() {
    headerCtrl.dispose();
    card1Ctrl.dispose();
    card2Ctrl.dispose();
    super.onClose();
  }
}
