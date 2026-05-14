import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/data/models/portfolio_info_model.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutController extends GetxController with GetTickerProviderStateMixin {
  // ── Animation ──────────────────────────────────────────────────────────────
  late AnimationController animCtrl;
  bool _animated = false;

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      animCtrl.forward();
    }
  }

  // ── Data state ─────────────────────────────────────────────────────────────
  final portfolioInfo = Rxn<PortfolioInfoModel>();
  final experiences = RxList<ExperienceModel>();

  /// Statistics from portfolio_info/statistics
  final statProjects = 0.obs;
  final statClients = 0.obs;
  final statYearsExp = 0.obs;

  final isLoading = true.obs;
  final hasError = false.obs;

  final _repo = PortfolioRepository.instance;
  StreamSubscription<PortfolioInfoModel>? _infoSub;
  StreamSubscription<List<ExperienceModel>>? _expSub;
  StreamSubscription<Map<String, dynamic>>? _statsSub;

  @override
  void onInit() {
    super.onInit();
    animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _subscribeInfo();
    _subscribeExperiences();
    _subscribeStatistics();
  }

  void _subscribeInfo() {
    _infoSub = _repo.watchPortfolioInfo().listen(
      (info) {
        portfolioInfo.value = info;
        _checkLoaded();
      },
      onError: (error, stack) {
        hasError.value = true;
        isLoading.value = false;
      },
    );
  }

  void _subscribeExperiences() {
    _expSub = _repo.watchExperiences().listen(
      (list) {
        experiences.assignAll(list);
        _checkLoaded();
      },
      onError: (error, stack) {
        hasError.value = true;
        isLoading.value = false;
      },
    );
  }

  void _subscribeStatistics() {
    _statsSub = _repo.watchStatistics().listen(
      (data) {
        statProjects.value = (data['projects'] as num?)?.toInt() ?? 0;
        statClients.value = (data['clients'] as num?)?.toInt() ?? 0;
        statYearsExp.value = (data['years_exp'] as num?)?.toInt() ?? 0;
      },
      onError: (_, __) {}, // Non-critical — stats stay at 0 on error
    );
  }

  void _checkLoaded() {
    if (portfolioInfo.value != null) {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _infoSub?.cancel();
    _expSub?.cancel();
    _statsSub?.cancel();
    animCtrl.dispose();
    super.onClose();
  }
}
