import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/widgets/custom_text.dart';

class ProjectCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String year;
  final String title;
  final String description;
  final List<String> technologies;

  const ProjectCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.year,
    required this.title,
    required this.description,
    required this.technologies,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXl),
            ),
            child: Container(
              height: 240,
              width: double.infinity,
              color: AppColors.heroBackground, // placeholder
              child: const Icon(
                Icons.image_outlined,
                size: 48,
                color: AppColors.border,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges
                Row(
                  children: [
                    _buildBadge(category, outline: false),
                    const SizedBox(width: AppSizes.sm),
                    _buildBadge(year, outline: true),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
                // Title
                CustomText(
                  text: title,
                  style: CustomTextStyle.h3,
                  fontSize: 22,
                ),
                const SizedBox(height: AppSizes.sm),
                // Description
                CustomText(
                  text: description,
                  style: CustomTextStyle.bodyMedium,
                  color: AppColors.textSecondary,
                  maxLines: 3,
                  height: 1.5,
                ),
                const SizedBox(height: AppSizes.xl),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: technologies.join('   '),
                      style: CustomTextStyle.caption,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: const Icon(
                        Icons.arrow_outward_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, {required bool outline}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 4,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: outline ? Colors.transparent : AppColors.badgeBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: outline ? Border.all(color: AppColors.border) : null,
      ),
      child: CustomText(
        text: text,
        style: CustomTextStyle.caption,
        color: outline ? AppColors.textSecondary : AppColors.badgeText,
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
    );
  }
}
