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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kWhiteColor),
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
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Image.network(pokemonData.defaultSprite, width: 200, height: 200, fit: BoxFit.contain,),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                Text(
                  'Pokémon obtenu : ${pokemonData.name[0].toUpperCase() + pokemonData.name.substring(1)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kWhiteColor,
                  ),
                ),
                Text('Type : ${pokemonData.type[0].toUpperCase() + pokemonData.type.substring(1)}',
                  style: const TextStyle(color: kWhiteColor),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                AppElevatedButton(
                  buttonColor: kWhiteColor,
                  textColor: kBlackColor,
                  buttonText: 'Voir mon Pokedex',
                  onPressed: () {
                    context.pushReplacementNamed('pokedex');
                  },
                ),
                const SizedBox(height: 16),
                AppElevatedButton(
                  buttonColor: kBlackColor,
                  textColor: kWhiteColor,
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
