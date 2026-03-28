import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HeroAnimController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animCtrl;
  bool _animated = false;

  @override
  void onInit() {
    super.onInit();
    animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    // Home section is always visible on load – animate immediately
    Future.microtask(() => animCtrl.forward());
  }

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      animCtrl.forward();
    }
  }

  @override
  void onClose() {
    animCtrl.dispose();
    super.onClose();
  }
}
