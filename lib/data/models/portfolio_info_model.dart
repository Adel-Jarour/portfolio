import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioInfoModel {
  // Existing textual fields
  final String name;
  final String bio;
  final String tagline;
  final String email;
  final String github;
  final String linkedin;
  final String location;
  final String image;

  // New statistics fields
  final int clients;
  final int projects;
  final int yearsExp;

  const PortfolioInfoModel({
    required this.name,
    required this.bio,
    required this.tagline,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.location,
    this.image = '',
    this.clients = 0,
    this.projects = 0,
    this.yearsExp = 0,
  });

  factory PortfolioInfoModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return PortfolioInfoModel(
      name: data['name'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      tagline: data['tagline'] as String? ?? '',
      email: data['email'] as String? ?? '',
      github: data['github'] as String? ?? '',
      linkedin: data['linkedin'] as String? ?? '',
      location: data['location'] as String? ?? '',
      image: data['image'] as String? ?? '',
      clients: (data['clients'] as num?)?.toInt() ?? 0,
      projects: (data['projects'] as num?)?.toInt() ?? 0,
      yearsExp: (data['years_exp'] as num?)?.toInt() ?? 0,
    );
  }

  /// Fallback used while data is loading or on error.
  static PortfolioInfoModel empty() => const PortfolioInfoModel(
        name: '',
        bio: '',
        tagline: '',
        email: '',
        github: '',
        linkedin: '',
        location: '',
        image: '',
        clients: 0,
        projects: 0,
        yearsExp: 0,
      );
}
