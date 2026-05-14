import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExperienceModel {
  final String title;
  final String company;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  /// Icon key stored in Firestore (e.g. "school", "code", "work", "military").
  /// Falls back to "work" when not set.
  final String icon;

  const ExperienceModel({
    required this.title,
    required this.company,
    required this.description,
    required this.startDate,
    this.endDate,
    this.icon = 'work',
  });

  factory ExperienceModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};

    DateTime parseDate(dynamic raw) {
      if (raw is Timestamp) return raw.toDate();
      if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return ExperienceModel(
      title: data['title'] as String? ?? '',
      company: data['company'] as String? ?? '',
      description: data['description'] as String? ?? '',
      startDate: parseDate(data['start_date']),
      endDate:
          data['end_date'] != null ? parseDate(data['end_date']) : null,
      icon: data['icon'] as String? ?? 'work',
    );
  }

  /// Maps the [icon] string from Firestore to a Flutter [IconData].
  IconData get iconData {
    switch (icon.toLowerCase().trim()) {
      case 'school':
      case 'education':
      case 'university':
        return Icons.school_rounded;
      case 'code':
      case 'developer':
      case 'software':
        return Icons.code_rounded;
      case 'military':
      case 'army':
      case 'defense':
        return Icons.security_rounded;
      case 'design':
      case 'ui':
      case 'ux':
        return Icons.design_services_rounded;
      case 'mobile':
      case 'flutter':
      case 'android':
      case 'ios':
        return Icons.phone_android_rounded;
      case 'web':
      case 'frontend':
      case 'backend':
        return Icons.web_rounded;
      case 'internship':
      case 'intern':
        return Icons.work_history_rounded;
      case 'freelance':
        return Icons.laptop_rounded;
      case 'work':
      default:
        return Icons.work_outline_rounded;
    }
  }

  /// Formatted date range, e.g. "Jan 2023 – Mar 2024" or "Jan 2023 – Present"
  String get dateRange {
    String fmt(DateTime d) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[d.month - 1]} ${d.year}';
    }

    final end = endDate != null ? fmt(endDate!) : 'Present';
    return '${fmt(startDate)} – $end';
  }
}
