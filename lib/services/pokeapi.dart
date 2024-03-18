import 'package:be_sacha/models/pokemon.dart';
import 'package:be_sacha/services/app_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/app_user.dart';
import 'dart:convert';
import 'dart:math';

import 'app_firebase.dart';

class PokeApi {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  static Future<Pokemon> fetchPokemonApi(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  static int getRandomPokemonId() {
    final random = Random();
    return random.nextInt(1025) + 1;
  }

  static Future<Pokemon?> getDailyPokemon() async {
    AppUser? appUser = await AppUserService.getUser();
    if (appUser!.dailyPokemonDate.day >= DateTime.now().day) return null;

    int randomId = getRandomPokemonId();
    Pokemon pokemon = await fetchPokemonApi(randomId);

    appUser.dailyPokemonDate = DateTime.now();
    appUser.pokemons ??= [];
    appUser.pokemons!.add(pokemon.id);
    await AppUserService.updateUser(appUser);
    return pokemon;
  }
}
