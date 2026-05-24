import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String category;
  final String year;
  final String description;
  final List<String> technologies;
  final String? codeUrl;
  final String? image;
  final bool isDark;

  const ProjectCard({
    super.key,
    required this.title,
    required this.category,
    required this.year,
    required this.description,
    required this.technologies,
    this.codeUrl,
    this.image,
    this.isDark = false,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final raw = widget.codeUrl;
    if (raw == null || raw.isEmpty) return;
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final hasLink = widget.codeUrl?.isNotEmpty == true;

    return GestureDetector(
      onTap: hasLink ? _launchUrl : null,
      child: MouseRegion(
        cursor: hasLink ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.4)
                : (isDark ? AppColors.darkBorder : AppColors.borderLight),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.10)
                  : Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
              blurRadius: _isHovered ? 32 : 20,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusXl),
              ),
              child: SizedBox(
                height: 240,
                width: double.infinity,
                child: (widget.image == null || widget.image!.isEmpty)
                    ? _buildPlaceholder(isDark)
                    : Image.network(
                        widget.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(isDark);
                        },
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
                      if (widget.category.isNotEmpty)
                        _buildBadge(widget.category,
                            outline: false, isDark: isDark),
                      if (widget.category.isNotEmpty && widget.year.isNotEmpty)
                        const SizedBox(width: AppSizes.sm),
                      if (widget.year.isNotEmpty)
                        _buildBadge(widget.year,
                            outline: true, isDark: isDark),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  // Title
                  CustomText(
                    text: widget.title,
                    style: CustomTextStyle.h3,
                    fontSize: 22,
                    color: isDark ? AppColors.darkText : null,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  // Description
                  CustomText(
                    text: widget.description,
                    style: CustomTextStyle.bodyMedium,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    maxLines: 3,
                    height: 1.5,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.technologies.isNotEmpty)
                        Expanded(
                          child: CustomText(
                            text: widget.technologies.join('   '),
                            style: CustomTextStyle.caption,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (hasLink)
                        GestureDetector(
                          onTap: _launchUrl,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isHovered
                                  ? AppColors.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: _isHovered
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.borderLight),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_outward_rounded,
                              color: _isHovered ? Colors.white : AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildBadge(String text,
      {required bool outline, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 4,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: outline
            ? Colors.transparent
            : (isDark ? AppColors.darkBadgeBg : AppColors.badgeBg),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: outline
            ? Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border)
            : null,
      ),
      child: CustomText(
        text: text,
        style: CustomTextStyle.caption,
        color: outline
            ? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
            : (isDark ? AppColors.darkBadgeText : AppColors.badgeText),
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkHero : AppColors.heroBackground,
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: isDark ? AppColors.darkBorder : AppColors.border,
      ),
    );
  }
}
