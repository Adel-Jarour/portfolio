import 'package:portfolio/core/services/firestore_service.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/data/models/portfolio_info_model.dart';
import 'package:portfolio/data/models/project_model.dart';
import 'package:portfolio/data/models/skill_model.dart';

/// Business-logic layer between [FirestoreService] and the GetX controllers.
/// Centralises error handling and could cache or transform data here.
class PortfolioRepository {
  PortfolioRepository._();
  static final PortfolioRepository instance = PortfolioRepository._();

  final _service = FirestoreService.instance;

  Stream<PortfolioInfoModel> watchPortfolioInfo() =>
      _service.watchPortfolioInfo();

  Stream<Map<String, dynamic>> watchStatistics() =>
      _service.watchStatistics();

  Stream<List<ExperienceModel>> watchExperiences() =>
      _service.watchExperiences();

  Stream<List<ProjectModel>> watchProjects() => _service.watchProjects();

  Stream<List<SkillModel>> watchSkills() => _service.watchSkills();
}
