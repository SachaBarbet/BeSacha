import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_design_system.dart';
import '../widgets/redirect_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bonjour ${FirebaseAuth.instance.currentUser!.displayName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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

        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDesignSystem.defaultPadding * 1.5,
              vertical: AppDesignSystem.defaultPadding,
            ),
            child: Column(
              children: [
                SizedBox(height: AppDesignSystem.defaultPadding * 2), // Spacer
                RedirectButton(redirectName: 'pokedex',buttonText: 'Pokedex',),
                SizedBox(height: AppDesignSystem.defaultPadding * 2), // Spacer
                RedirectButton(redirectName: 'friends',buttonText: 'Mes amis',),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
