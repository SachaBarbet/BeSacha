import 'package:flutter/material.dart';

import '../assets/app_design_system.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/redirect_button.dart';

class GameExplanationPage extends StatelessWidget {
  const GameExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Explanation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue dans le jeu Pokémon!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Le but du jeu est de compléter votre Pokedex en découvrant chaque jour un nouveau Pokémon.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Si vous êtes connectez, vous découvrirez automatiquement un nouveau Pokémon chaque jour lorsque vous lancerez l\'application. Vous pouvez également échanger le Pokémon d\'aujourd\'hui avec un ami.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            RedirectButton(redirectName: 'authentication', buttonText: 'Je comprends les règle de jeu',
                onPressed: (){
              SharedPreferencesService.write('rules', true);
            }),
          ],
        ),
      ),
    );
  }
}



