import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsAnimController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController titleCtrl;
  late List<AnimationController> cardCtrls;
  bool _animated = false;

  @override
  void onInit() {
    super.onInit();
    titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    cardCtrls = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      titleCtrl.forward();
      for (int i = 0; i < cardCtrls.length; i++) {
        Future.delayed(Duration(milliseconds: 200 + i * 150), () {
          cardCtrls[i].forward();
        });
      }
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    for (final c in cardCtrls) {
      c.dispose();
    }
    super.onClose();
  }
}
