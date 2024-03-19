import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/pokemon.dart';
import '../services/pokeapi_service.dart';
import '../widgets/redirect_button.dart';

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
      _pokemonDetailsFuture = PokeApiService.getDailyPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon du jour',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Container(),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
              future: _pokemonDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final pokemonData = snapshot.data;
                  if (pokemonData == null) {
                    return const Text('Aucun Pokémon trouvé');
                  }

                  return Column(
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
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            RedirectButton(
              redirectName: 'pokedex',
              buttonText: 'Voir mon pokedex',
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}


