import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';

class RedirectButton extends StatelessWidget {
  final String redirectName;
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final bool isSmall;
  final void Function()? onPressed;
  final bool enabled;

  const RedirectButton({
    super.key,
    required this.redirectName,
    required this.buttonText,
    this.buttonColor,
    this.textColor,
    this.onPressed,
    this.isSmall = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColorB = buttonColor ?? Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.pressed}) ?? AppColors.primary;
    Color textColorB = textColor ?? Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed}) ?? AppColors.white;
    List<Widget> rowChildren = [
      Text(buttonText,
        style: TextStyle(fontWeight: FontWeight.bold, color: textColorB,
          fontSize: isSmall ? AppDesignSystem.defaultFontSize * 0.8 : AppDesignSystem.defaultFontSize,
        ),
      ),
      Icon(
        Icons.arrow_forward,
        color: textColorB,
        size: isSmall ? AppDesignSystem.defaultFontSize : AppDesignSystem.defaultFontSize * 1.5,
      )
    ];

    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => buttonColorB)),
      onPressed: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        if (onPressed!=null && enabled) onPressed;
        if (redirectName.isNotEmpty && enabled) context.pushNamed(redirectName);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? AppDesignSystem.defaultPadding * 0.25 : AppDesignSystem.defaultPadding * 0.5,
          vertical: isSmall ? AppDesignSystem.defaultPadding * 0.75 : AppDesignSystem.defaultPadding * 1.5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren,
        ),
      ),
    );
  }
}