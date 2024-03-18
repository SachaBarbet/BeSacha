import 'package:be_sacha/models/pokemon.dart';
import 'package:be_sacha/pages/pokedex_page.dart';
import 'package:be_sacha/widgets/redirect_button.dart';
import 'package:flutter/material.dart';

import '../services/pokeapi.dart';

class PokemonScreen extends StatefulWidget {
  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  late Future<Pokemon> _pokemonDetailsFuture;
  late Pokemon _pokemonData;

  @override
  void initState() {
    super.initState();
    _fetchRandomPokemon();
  }

  Future<void> _fetchRandomPokemon() async {
    final randomId = await PokeApi.getRandomPokemonId();
    setState(() {
      _pokemonDetailsFuture = PokeApi.fetchPokemonApi(randomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon de jour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<Pokemon>(
              future: _pokemonDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final pokemonData = snapshot.data!;
                  return Column(
                    children: [

                      Image.network(pokemonData.imageUrl),
                      Text(
                        'Pokémon de jour: ${pokemonData.name}',
                        style: TextStyle(
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
            SizedBox(height: 16),
            RedirectButton(
              redirectName: 'pokedex',
              buttonText: 'Voir mon pokedex',
              // onPressed: () {
              //   // Navigate to PokedexPage and pass the Pokemon data
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => PokedexPage(pokemon: _pokemonData),
              //     ),
              //   );
              // },
            ),
          ],
        ),
      ),
    );
  }
}


