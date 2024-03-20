import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../services/settings_service.dart';
import '../widgets/redirect_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<Pokemon?> _dailyPokemon;

  final String _brightnessMode = SettingsService.getBrightnessMode();

  Color? _textColor;
  Color? _backgroundColor;

  @override
  void initState() {
    _dailyPokemon = PokemonService.getUserDailyPokemon();
    super.initState();
  }


  @override
  void activate() {
    _dailyPokemon = PokemonService.getUserDailyPokemon();
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    if (_brightnessMode != 'system') {
      _textColor = _brightnessMode == 'dark' ? kWhiteColor : kBlackColor;
      _backgroundColor = _brightnessMode == 'dark' ? kBlackColor : kLightGreyColor;
    } else {
      _textColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? kWhiteColor : kBlackColor;
      _backgroundColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? kBlackColor : kLightGreyColor;
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bonjour ${FirebaseAuth.instance.currentUser!.displayName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: Container(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: kDefaultPadding),
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
              horizontal: kDefaultPadding * 1.5,
              vertical: kDefaultPadding,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: kDefaultPadding*3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      ),
                      child: FutureBuilder(
                        future: _dailyPokemon,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Text('Une erreur est survenue');
                          }
                      
                          final Pokemon? pokemon = snapshot.data;
                          if (pokemon == null) {
                            return const Center(
                              child: Text('Aucun utilisateur/pokemon trouvé'),
                            );
                          }
                      
                      
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(pokemon.defaultSprite, width: 192, height: 192, fit: BoxFit.fill,),
                                  Text('Votre Pokémon actuel est ${pokemon.name[0].toUpperCase() + pokemon.name.substring(1)}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kDefaultPadding * 2), // Spacer
                const RedirectButton(redirectName: 'pokedex', buttonText: 'Pokedex',),
                const SizedBox(height: kDefaultPadding * 2), // Spacer
                const Padding(
                  padding: EdgeInsets.only(bottom: kDefaultPadding),
                  child: RedirectButton(redirectName: 'friends', buttonText: 'Mes amis',),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
