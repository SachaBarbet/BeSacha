import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../assets/app_images.dart';
import '../../widgets/app_elevated_button.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
              children: [
                Image.asset(
                  AppImages.appIconNoBackground,
                  height: 192,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: AppDesignSystem.defaultPadding * 7,
                    top: AppDesignSystem.defaultPadding,
                  ),
                  child: Text('Bienvenue sur BeSacha !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignSystem.defaultPadding,
                    vertical: AppDesignSystem.defaultPadding * 0.5,
                  ),
                  child: AppElevatedButton(
                    buttonColor: AppColors.black,
                    textColor: AppColors.white,
                    onPressed: () {
                      context.pushNamed('login');
                    },
                    buttonText: 'Connexion',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
                  child: AppElevatedButton(
                    buttonColor: AppColors.white,
                    textColor: AppColors.black,
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
