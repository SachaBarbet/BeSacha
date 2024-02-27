import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../widgets/app_elevated_button.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Text('Bienvenue', style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.defaultPadding,
                  ),
                  child: AppElevatedButton(
                    onPressed: () {
                      context.pushNamed('login');
                    },
                    buttonText: 'Connexion',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
                  child: AppElevatedButton(
                    buttonColor: AppColors.lightPrimary,
                    onPressed: () {
                      context.pushNamed('register');
                    },
                    buttonText: 'Inscription',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
