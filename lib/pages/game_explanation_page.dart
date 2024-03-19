import 'package:be_sacha/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_design_system.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/redirect_button.dart';

class GameExplanationPage extends StatelessWidget {
  const GameExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Règles du jeu'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 1.5,
          vertical: kDefaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue dans BeSacha !',
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
              'Si vous êtes connectez, vous découvrirez automatiquement un nouveau Pokémon chaque jour lorsque vous lancerez l\'application. Vous pouvez également échanger votre Pokémon d\'aujourd\'hui avec un ami.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppElevatedButton(
              buttonText: 'Je comprends les règles de jeu',
              onPressed: () async {
                await SharedPreferencesService.write('rules', true);
                if (!context.mounted) return;
                context.replaceNamed('authentication');
              },
            ),
          ],
        ),
      ),
    );
  }
}



