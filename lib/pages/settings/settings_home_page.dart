import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/app_user_service.dart';
import '../../widgets/redirect_button.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsHomePage();
}

class _SettingsHomePage extends State<SettingsHomePage> {
  late final Future<AppUser?> _user;

  static const double _dividerHeight = 50;

  @override
  void initState() {
    _user = AppUserService.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: FutureBuilder<AppUser?>(
          future: _user,
          builder: (BuildContext context, AsyncSnapshot<AppUser?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Text(
                  'Une erreur est survenue',
                  style: TextStyle(color: AppColors.red),
                ),
              );
            }

            if (snapshot.hasData) {
              final AppUser user = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour ${user.displayName}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
                    textAlign: TextAlign.left,
                  ),
                  const Text(
                    'Vos paramètres',
                    style: TextStyle(fontSize: 20, height: 1),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: _dividerHeight),
                  const Padding(
                    padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding * 0.6),
                    child: RedirectButton(
                      redirectName: 'user',
                      buttonText: 'Vos informations',
                    ),
                  ),
                  const RedirectButton(
                    redirectName: 'setting',
                    buttonText: 'Paramètres de l\'application',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
                    child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding * 0.6),
                    child: RedirectButton(
                      redirectName: 'cgu',
                      buttonText: 'Conditions générales d\'utilisation',
                    ),
                  ),
                  const RedirectButton(
                    redirectName: 'confidentiality',
                    buttonText: 'Politique de confidentialité',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
                    child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding * 0.6),
                    child: RedirectButton(
                      redirectName: 'about',
                      buttonText: 'À propos',
                    ),
                  ),
                  const RedirectButton(
                    redirectName: 'contact',
                    buttonText: 'Contact',
                  )
                ],
              );
            }
            return const Center(
              child: Text('Aucune donnée à afficher. Veuillez réessayer plus tard.'),
            );
          },
        ),
      ),
    );
  }
}