import 'package:flutter/material.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';

class AppElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool isSmall;
  final bool enabled;

  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.buttonColor = kPrimaryColor,
    this.textColor = kWhiteColor,
    this.isSmall = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];

    if (prefixIcon != null) {
      rowChildren.add(prefixIcon!);
    }

    rowChildren.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(buttonText,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor,
            fontSize: isSmall ? kDefaultFontSize * 0.8 : kDefaultFontSize,
          ),
        ),
      ),
    );

    if (suffixIcon != null) {
      rowChildren.add(suffixIcon!);
    }

    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => buttonColor)),
      onPressed: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        if (onPressed != null && enabled) onPressed!();
      },
      child: Padding(
        padding: EdgeInsets.all(isSmall ? kDefaultPadding * 0.5 : kDefaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren,
        ),
      ),
    );
  }

}