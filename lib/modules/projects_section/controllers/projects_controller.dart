import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/project_model.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsController extends GetxController
    with GetTickerProviderStateMixin {
  // ── Animation (mirrors ProjectsAnimController) ─────────────────────────────
  late AnimationController headerCtrl;
  late AnimationController card1Ctrl;
  late AnimationController card2Ctrl;
  bool _animated = false;

  final scrollController = ScrollController();
  final currentIndex = 0.obs;
  final scrollNotifier = ValueNotifier<double>(0.0);
  bool _isAnimating = false;

  void scrollNext(double itemStep, int maxIndex) {
    if (currentIndex.value < maxIndex && !_isAnimating) {
      _isAnimating = true;
      currentIndex.value++;
      scrollController.animateTo(
        currentIndex.value * itemStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) => _isAnimating = false);
    }
  }

  void scrollBack(double itemStep) {
    if (currentIndex.value > 0 && !_isAnimating) {
      _isAnimating = true;
      currentIndex.value--;
      scrollController.animateTo(
        currentIndex.value * itemStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) => _isAnimating = false);
    }
  }

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
    
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;
      if (_isAnimating) return;

      final screenWidth = Get.width;
      final isMobile = screenWidth <= AppSizes.mobileBreakpoint;
      final isTablet = screenWidth <= AppSizes.tabletBreakpoint && !isMobile;
      
      final fullVisible = isMobile ? 1 : 2;
      final gap = isMobile ? 16.0 : (isTablet ? 20.0 : 24.0);
      const peekFraction = 0.15;
      final viewportWidth = scrollController.position.viewportDimension;
      final cardWidth = (viewportWidth - fullVisible * gap) / (fullVisible + peekFraction);
      final itemStep = cardWidth + gap;
      
      final maxIndex = projects.length - fullVisible;
      if (maxIndex <= 0) return;
      
      final offset = scrollController.offset;
      final newIndex = (offset / itemStep).round().clamp(0, maxIndex);
      if (currentIndex.value != newIndex) {
        currentIndex.value = newIndex;
      }
    });

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
    scrollNotifier.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
