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
    Color buttonColorB = buttonColor ?? Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.pressed}) ?? kPrimaryColor;
    Color textColorB = textColor ?? Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed}) ?? kWhiteColor;
    List<Widget> rowChildren = [
      Text(buttonText,
        style: TextStyle(fontWeight: FontWeight.bold, color: textColorB,
          fontSize: isSmall ? kDefaultFontSize * 0.8 : kDefaultFontSize,
        ),
      ),
      Icon(
        Icons.arrow_forward,
        color: textColorB,
        size: isSmall ? kDefaultFontSize : kDefaultFontSize * 1.5,
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
          horizontal: isSmall ? kDefaultPadding * 0.25 : kDefaultPadding * 0.5,
          vertical: isSmall ? kDefaultPadding * 0.75 : kDefaultPadding * 1.5,
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