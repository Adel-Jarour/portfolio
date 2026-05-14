import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/data/models/portfolio_info_model.dart';
import 'package:portfolio/data/models/project_model.dart';
import 'package:portfolio/data/models/skill_model.dart';

/// Thin wrapper around FirebaseFirestore — only responsible for raw data access.
/// All business logic lives in [PortfolioRepository].
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  // ── portfolio_info ──────────────────────────────────────────────────────────

  Stream<PortfolioInfoModel> watchPortfolioInfo() {
    return _db
        .collection('portfolio_info')
        .doc('main')
        .snapshots()
        .map(PortfolioInfoModel.fromFirestore);
  }

  /// Watches the `portfolio_info/statistics` document.
  /// Returns a Map with keys: clients, projects, years_exp.
  Stream<Map<String, dynamic>> watchStatistics() {
    return _db
        .collection('portfolio_info')
        .doc('statistics')
        .snapshots()
        .map((snap) {
          final Map<String, dynamic> data =
              snap.data() ?? {};
          return data;
        });
  }

  // ── experiences ────────────────────────────────────────────────────────────

  Stream<List<ExperienceModel>> watchExperiences() {
    return _db
        .collection('experiences')
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map(ExperienceModel.fromFirestore)
          .toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate)); // newest first
      return list;
    });
  }

  // ── projects ───────────────────────────────────────────────────────────────

  Stream<List<ProjectModel>> watchProjects() {
    return _db
        .collection('projects')
        .orderBy(FieldPath.documentId)
        .snapshots()
        .map((snap) => snap.docs.map(ProjectModel.fromFirestore).toList());
  }

  // ── skills ─────────────────────────────────────────────────────────────────

  Stream<List<SkillModel>> watchSkills() {
    return _db
        .collection('skills')
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map(SkillModel.fromFirestore)
          .toList()
        ..sort((a, b) {
          final typeComp = a.type.compareTo(b.type);
          if (typeComp != 0) return typeComp;
          return b.level.compareTo(a.level); // higher level first
        });
      return list;
    });
  }
}
