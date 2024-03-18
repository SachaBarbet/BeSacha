import 'package:flutter/material.dart';

import '../widgets/redirect_button.dart';

class GameExplanationPage extends StatelessWidget {
  const GameExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Explanation'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Pokemon Pokedex Game!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'The goal of the game is to complete your Pokedex by discovering a new Pokemon every day.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'If you are logged in, you will automatically discover a new Pokemon each day when you launch the application. You can also swap today\'s Pokemon with a friend.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            RedirectButton(redirectName: 'login', buttonText: 'I understand'),
            
            SizedBox(height: 20),
            Text('I Understand, Let\'s Start!'),
          ],
        ),
      ),
    );
  }
}



