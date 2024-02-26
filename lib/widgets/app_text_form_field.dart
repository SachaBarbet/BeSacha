import 'package:flutter/material.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';

class AppTextFormField extends StatefulWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AppTextFormField({
    super.key, this.hintText,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormField();
}

class _AppTextFormField extends State<AppTextFormField> {
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
        errorStyle: const TextStyle(color: AppColors.red),
        hintStyle: const TextStyle(color: AppColors.grey),
        labelStyle: const TextStyle(color: AppColors.black),
        hintText: widget.hintText,
        fillColor: AppColors.grey.withOpacity(0.2),
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
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: AppColors.black, size: 20),
          ),
        ) : null,
      ),
      style: const TextStyle(color: AppColors.black),
      cursorColor: AppColors.black,
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}