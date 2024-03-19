import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_design_system.dart';
import '../../widgets/redirect_button.dart';


class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: const Text('Vos paramètres', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 1.5,
          vertical: kDefaultPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: kDefaultPadding * 0.6),
              child: RedirectButton(redirectName: 'user', buttonText: 'Vos informations',),
            ),
            RedirectButton(redirectName: 'setting', buttonText: 'Paramètres de l\'application',),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
              child: SizedBox(height: kDividerHeight, width: double.infinity, child: Divider()),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: kDefaultPadding * 0.6),
              child: RedirectButton(redirectName: 'cgu', buttonText: 'Conditions générales d\'utilisation',),
            ),
            RedirectButton(redirectName: 'confidentiality', buttonText: 'Politique de confidentialité',),
          ],
        ),
      ),
    );
  }
}