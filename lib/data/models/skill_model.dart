import 'package:cloud_firestore/cloud_firestore.dart';

class SkillModel {
  final String name;
  final String type; // raw value from Firestore: language, libraries, framework, database, tools, concepts
  final int level; // 1–100

  const SkillModel({
    required this.name,
    required this.type,
    required this.level,
  });

  factory SkillModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return SkillModel(
      name: data['name'] as String? ?? '',
      type: data['type'] as String? ?? '',
      level: (data['level'] as num?)?.toInt() ?? 0,
    );
  }

  /// Maps the raw Firestore `type` to one of the 4 display categories.
  String get categoryKey {
    switch (type.toLowerCase().trim()) {
      case 'language':
      case 'languages':
        return 'Languages';
      case 'library':
      case 'libraries':
      case 'framework':
      case 'frameworks':
        return 'Libraries & Frameworks';
      case 'database':
      case 'databases':
        return 'Databases';
      case 'tool':
      case 'tools':
      case 'concept':
      case 'concepts':
      default:
        return 'Tools & Concepts';
    }
  }
}
