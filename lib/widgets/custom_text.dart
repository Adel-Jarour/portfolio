import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_text_styles.dart';

enum CustomTextStyle {
  h1,
  h2,
  h3,
  h4,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
  button,
  navLink,
}

class CustomText extends StatelessWidget {
  final String text;
  final CustomTextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomText({
    super.key,
    required this.text,
    this.style = CustomTextStyle.bodyMedium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
  });

  TextStyle get _baseStyle {
    switch (style) {
      case CustomTextStyle.h1:
        return AppTextStyles.h1;
      case CustomTextStyle.h2:
        return AppTextStyles.h2;
      case CustomTextStyle.h3:
        return AppTextStyles.h3;
      case CustomTextStyle.h4:
        return AppTextStyles.h4;
      case CustomTextStyle.bodyLarge:
        return AppTextStyles.bodyLarge;
      case CustomTextStyle.bodyMedium:
        return AppTextStyles.bodyMedium;
      case CustomTextStyle.bodySmall:
        return AppTextStyles.bodySmall;
      case CustomTextStyle.caption:
        return AppTextStyles.caption;
      case CustomTextStyle.button:
        return AppTextStyles.button;
      case CustomTextStyle.navLink:
        return AppTextStyles.navLink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _baseStyle.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
