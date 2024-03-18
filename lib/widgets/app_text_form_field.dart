import 'package:flutter/material.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';
import '../services/settings_service.dart';

class AppTextFormField extends StatefulWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;
  final void Function()? onChanged;

  const AppTextFormField({
    super.key, this.hintText,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormField();
}

class _AppTextFormField extends State<AppTextFormField> {
  bool _obscureText = false;

  String _brightnessMode = SettingsService.getBrightnessMode();

  static const double borderWidth = 2;
  Color? foregroundColor;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_brightnessMode != 'system') {
      foregroundColor = _brightnessMode == 'dark' ? AppColors.white : AppColors.black;
    } else {
      foregroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? AppColors.white : AppColors.black;
    }
    return TextFormField(
      enabled: widget.enabled,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.grey, width: borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.grey, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: BorderSide(color: foregroundColor!, width: borderWidth),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.red, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.red, width: borderWidth),
        ),
        errorStyle: const TextStyle(color: AppColors.red),
        hintStyle: const TextStyle(color: AppColors.grey),
        labelStyle: TextStyle(color: foregroundColor),
        hintText: widget.hintText,
        fillColor: AppColors.grey.withOpacity(0.25),
        filled: true,
        contentPadding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
        suffixIcon: widget.obscureText ? Material(
          borderRadius:const BorderRadius.horizontal(right: Radius.circular(AppDesignSystem.defaultBorderRadius)),
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: foregroundColor, size: 20),
          ),
        ) : null,
      ),
      style: TextStyle(color: foregroundColor),
      cursorColor: foregroundColor,
      validator: widget.validator,
      controller: widget.controller,
      onChanged: (value) => widget.onChanged?.call(),
    );
  }
}