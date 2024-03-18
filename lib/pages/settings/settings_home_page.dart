import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_design_system.dart';
import '../../widgets/redirect_button.dart';


class SettingsHomePage extends StatelessWidget {
  static const double _dividerHeight = 50;

  const SettingsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop(),),),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: ListView(
          children: const [
            Text('Vos paramètres', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),),
            SizedBox(height: _dividerHeight * 3),
            Padding(
              padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding * 0.6),
              child: RedirectButton(redirectName: 'user', buttonText: 'Vos informations',),
            ),
            RedirectButton(redirectName: 'setting', buttonText: 'Paramètres de l\'application',),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
              child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding * 0.6),
              child: RedirectButton(redirectName: 'cgu', buttonText: 'Conditions générales d\'utilisation',),
            ),
            RedirectButton(redirectName: 'confidentiality', buttonText: 'Politique de confidentialité',),
          ],
        ),
      ),
    );
  }
}