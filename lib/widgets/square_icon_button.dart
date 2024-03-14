import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';

class SquaredIconButton extends StatelessWidget {
  final IconData iconData;
  final Color? backgroundColor;
  final Color? iconColor;
  final void Function()? onPressed;

  const SquaredIconButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColorB = backgroundColor ?? Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.pressed}) ?? AppColors.primary;
    Color iconColorB = iconColor ?? Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed}) ?? AppColors.white;

    return InkWell(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        if (onPressed != null) onPressed!();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          color: backgroundColorB,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Center(
            child: Icon(
              iconData,
              color: iconColorB,
            ),
          ),
        ),
      ),
    );
  }
}