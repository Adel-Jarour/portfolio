import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/portfolio_info_model.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactAnimController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animCtrl;
  bool _animated = false;

  final portfolioInfo = Rxn<PortfolioInfoModel>();
  final _repo = PortfolioRepository.instance;
  StreamSubscription<PortfolioInfoModel>? _infoSub;

  @override
  void onInit() {
    super.onInit();
    animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _subscribeInfo();
  }

  void _subscribeInfo() {
    _infoSub = _repo.watchPortfolioInfo().listen((info) {
      portfolioInfo.value = info;
    });
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
