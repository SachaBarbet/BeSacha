import 'dart:convert';
import 'dart:math';

import 'package:be_sacha/utilities/app_utils.dart';
import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/pokemon.dart';
import 'app_user_service.dart';

class PokeApiService {
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
    String formattedDate = getFormattedDate();
    if (appUser!.dailyPokemonDate != formattedDate) return null;

    int randomId = getRandomPokemonId();
    Pokemon pokemon = await fetchPokemonApi(randomId);

    appUser.dailyPokemonDate = formattedDate;
    appUser.dailyPokemonId = randomId;
    appUser.pokemons[pokemon.id] = formattedDate;
    await AppUserService.updateUser(appUser);
    return pokemon;
  }
}