import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/skill_model.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsController extends GetxController
    with GetTickerProviderStateMixin {
  // ── Animation ──────────────────────────────────────────────────────────────
  late AnimationController titleCtrl;
  late List<AnimationController> cardCtrls;
  bool _animated = false;

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      titleCtrl.forward();
      final count = cardCtrls.length;
      for (int i = 0; i < count; i++) {
        Future.delayed(Duration(milliseconds: 200 + i * 150), () {
          if (!isClosed) cardCtrls[i].forward();
        });
      }
    }
  }

  // ── Data state ─────────────────────────────────────────────────────────────
  final skills = RxList<SkillModel>();
  final isLoading = true.obs;
  final hasError = false.obs;

  final _repo = PortfolioRepository.instance;
  StreamSubscription<List<SkillModel>>? _skillsSub;

  /// Fixed category order for display.
  static const _categoryOrder = [
    'Languages',
    'Libraries & Frameworks',
    'Databases',
    'Tools & Concepts',
  ];

  /// Skills grouped by their `categoryKey`, in the fixed display order.
  Map<String, List<SkillModel>> get groupedSkills {
    final map = <String, List<SkillModel>>{};
    for (final s in skills) {
      map.putIfAbsent(s.categoryKey, () => []).add(s);
    }
    // Sort skills within each group by level descending.
    for (final list in map.values) {
      list.sort((a, b) => b.level.compareTo(a.level));
    }
    // Return in fixed category order, skipping empty categories.
    final ordered = <String, List<SkillModel>>{};
    for (final cat in _categoryOrder) {
      if (map.containsKey(cat)) {
        ordered[cat] = map[cat]!;
      }
    }
    return ordered;
  }

  @override
  void onInit() {
    super.onInit();
    titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    // Start with 4 card controllers (one per category).
    cardCtrls = List.generate(
      4,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    _subscribe();
  }

  void _subscribe() {
    _skillsSub = _repo.watchSkills().listen(
      (list) {
        skills.assignAll(list);
        _resizeCardCtrls(groupedSkills.length);
        isLoading.value = false;
      },
      onError: (error, stack) {
        print('[SkillsController] error: $error');
        hasError.value = true;
        isLoading.value = false;
      },
    );
  }

  void _resizeCardCtrls(int count) {
    if (count == cardCtrls.length) return;
    for (final c in cardCtrls) {
      c.dispose();
    }
    cardCtrls = List.generate(
      count,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    _animated = false; // allow re-animation after resize
  }

  @override
  void onClose() {
    _skillsSub?.cancel();
    titleCtrl.dispose();
    for (final c in cardCtrls) {
      c.dispose();
    }
    super.onClose();
  }
}
