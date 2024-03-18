import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_design_system.dart';
import '../widgets/redirect_button.dart';

class HomePage extends StatelessWidget {
  static const double _dividerHeight = 50;

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppDesignSystem.defaultPadding),
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                   context.pushNamed('settings');
                },
              ),
            ),
          ],
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.defaultPadding * 1.5,
              vertical: AppDesignSystem.defaultPadding,
            ),
            child: Column(
              children: [
                Text('Bonjour ${FirebaseAuth.instance.currentUser!.displayName}', style: const TextStyle(fontSize: 24),),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 4),
                  child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
                ),
                const SizedBox(height: AppDesignSystem.defaultPadding * 2), // Spacer
                const RedirectButton(redirectName: 'pokedex',buttonText: 'Pokedex',),
                const SizedBox(height: AppDesignSystem.defaultPadding * 2), // Spacer
                const RedirectButton(redirectName: 'friends',buttonText: 'Mes amis',),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
