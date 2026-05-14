import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_sizes.dart';
import 'package:portfolio/data/models/experience_model.dart';
import 'package:portfolio/widgets/custom_text.dart';

class ExperienceTimeline extends StatelessWidget {
  final bool isDark;
  final List<ExperienceModel> experiences;

  const ExperienceTimeline({
    super.key,
    this.isDark = false,
    required this.experiences,
  });

  @override
  Widget build(BuildContext context) {
    if (experiences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(experiences.length, (index) {
        final item = experiences[index];
        final isLast = index == experiences.length - 1;
        return _TimelineEntry(item: item, isLast: isLast, isDark: isDark);
      }),
    );
  }
}

class _TimelineEntry extends StatefulWidget {
  final ExperienceModel item;
  final bool isLast;
  final bool isDark;

  const _TimelineEntry({
    required this.item,
    required this.isLast,
    required this.isDark,
  });

  @override
  State<_TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends State<_TimelineEntry> {
  final _contentKey = GlobalKey();
  double _contentHeight = 0;

  @override
  void initState() {
    super.initState();
    // Measure content height after first frame so the line can span it fully.
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final box =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final h = box.size.height;
    if (h != _contentHeight) {
      setState(() => _contentHeight = h);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isLast = widget.isLast;
    final isDark = widget.isDark;

    // Height of the icon circle.
    const iconSize = 40.0;
    // The connector starts right below the icon and should reach the
    // bottom of the content area (minus the bottom padding gap).
    final lineHeight =
        (_contentHeight - iconSize).clamp(0.0, double.infinity);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left: icon + connector line ──────────────────────────────────
        SizedBox(
          width: 40,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Connector line — extends below the icon into next entry
              if (!isLast && lineHeight > 0)
                Positioned(
                  top: iconSize,
                  child: Container(
                    width: 2,
                    height: lineHeight,
                    color: AppColors.primary.withValues(alpha: 0.20),
                  ),
                ),
              // Icon circle
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
                child: Icon(
                  item.iconData,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.md),

        // ── Right: content ───────────────────────────────────────────────
        Expanded(
          child: Padding(
            key: _contentKey,
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomText(
                  text: item.title,
                  style: CustomTextStyle.h4,
                  fontSize: 17,
                  color: isDark ? AppColors.darkText : null,
                ),
                const SizedBox(height: 2),
                // Company
                CustomText(
                  text: item.company,
                  style: CustomTextStyle.bodySmall,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                // Date range
                CustomText(
                  text: item.dateRange,
                  style: CustomTextStyle.caption,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                // Description – only when non-empty
                if (item.description.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSizes.sm),
                  CustomText(
                    text: item.description,
                    style: CustomTextStyle.bodySmall,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
