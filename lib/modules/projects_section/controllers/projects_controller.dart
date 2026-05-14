import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/project_model.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsController extends GetxController
    with GetTickerProviderStateMixin {
  // ── Animation (mirrors ProjectsAnimController) ─────────────────────────────
  late AnimationController headerCtrl;
  late AnimationController card1Ctrl;
  late AnimationController card2Ctrl;
  bool _animated = false;

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      headerCtrl.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!isClosed) card1Ctrl.forward();
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!isClosed) card2Ctrl.forward();
      });
    }
  }

  // ── Data state ─────────────────────────────────────────────────────────────
  final projects = RxList<ProjectModel>();
  final isLoading = true.obs;
  final hasError = false.obs;

  final _repo = PortfolioRepository.instance;
  StreamSubscription<List<ProjectModel>>? _projectsSub;

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
    _subscribe();
  }

  void _subscribe() {
    _projectsSub = _repo.watchProjects().listen(
      (list) {
        projects.assignAll(list);
        isLoading.value = false;
      },
      onError: (error, stack) {
        print('[ProjectsController] error: $error');
        hasError.value = true;
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _projectsSub?.cancel();
    headerCtrl.dispose();
    card1Ctrl.dispose();
    card2Ctrl.dispose();
    super.onClose();
  }
}
