import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/app_elevated_button.dart';

class DailyPokemonScreen extends StatefulWidget {
  const DailyPokemonScreen({super.key});

  @override
  State<DailyPokemonScreen> createState() => _DailyPokemonScreenState();
}

class _DailyPokemonScreenState extends State<DailyPokemonScreen> {
  late Future<Pokemon?> _pokemonDetailsFuture;

  @override
  void initState() {
    super.initState();
    _fetchRandomPokemon();
  }

  void _fetchRandomPokemon() {
    setState(() {
      _pokemonDetailsFuture = PokemonService.getDailyPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Pokémon du jour',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Container(),
        backgroundColor: kPrimaryColor,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5, vertical: kDefaultPadding,),
        child: FutureBuilder(
          future: _pokemonDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final Pokemon? pokemonData = snapshot.data;
            if (pokemonData == null) {
              return const Center(
                  child: Text('Aucun Pokémon trouvé, vous avez peut être déjà récupéré votre Pokemon aujourd\'hui',
                    textAlign: TextAlign.center,),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(pokemonData.defaultSprite),
                Text(
                  'Pokémon du jour: ${pokemonData.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Type: ${pokemonData.type}'),
                const SizedBox(height: 16),
                AppElevatedButton(
                  buttonColor: kWhiteColor,
                  textColor: kBlackColor,
                  buttonText: 'Voir mon pokedex',
                  onPressed: () {
                    context.pop();
                    context.pushNamed('pokedex');
                  },
                ),
                const SizedBox(height: 16),
                AppElevatedButton(
                  buttonColor: kWhiteColor,
                  textColor: kBlackColor,
                  onPressed: () {
                    context.pop();
                  },
                  buttonText: 'Continuer',
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
