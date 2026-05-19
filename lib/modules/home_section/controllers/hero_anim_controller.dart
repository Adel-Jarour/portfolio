import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/portfolio_info_model.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HeroAnimController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animCtrl;
  bool _animated = false;

  // Stream state
  final portfolioInfo = Rxn<PortfolioInfoModel>();
  final isLoading = true.obs;
  StreamSubscription<PortfolioInfoModel>? _infoSub;

  @override
  void onInit() {
    super.onInit();
    animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    // Home section is always visible on load – animate immediately
    Future.microtask(() => animCtrl.forward());
    _subscribeInfo();
  }

  void _subscribeInfo() {
    _infoSub = PortfolioRepository.instance.watchPortfolioInfo().listen(
      (info) {
        portfolioInfo.value = info;
        isLoading.value = false;
      },
      onError: (error, stack) {
        isLoading.value = false;
      },
    );
  }

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      animCtrl.forward();
    }
  }

  @override
  void onClose() {
    _infoSub?.cancel();
    animCtrl.dispose();
    super.onClose();
  }
}
