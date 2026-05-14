import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String status;
  final String? code; // GitHub / live URL

  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.code,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return ProjectModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      status: data['status'] as String? ?? '',
      code: data['code'] as String?,
    );
  }
}
