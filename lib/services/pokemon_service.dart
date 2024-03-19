import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_user.dart';
import '../models/pokemon.dart';
import '../utilities/app_utils.dart';
import 'app_user_service.dart';
import 'shared_preferences_service.dart';

class PokemonService {
  static final Reference _storageRefPokemonDatabase = FirebaseStorage.instance
      .ref('pokemon_databases/pokemon_database.db');

  static Future<void> initPokemonDatabase() async {

    final FullMetadata databaseMetadata = await _storageRefPokemonDatabase.getMetadata();

    DateTime? lastUpdatedRemote = databaseMetadata.updated;

    String? lastUpdateLocalSharedPreferences = SharedPreferencesService.read('lastUpdated');
    lastUpdateLocalSharedPreferences ??= '1970-01-01T00:00:00.000Z';
    final DateTime lastUpdatedLocal = DateTime.tryParse(lastUpdateLocalSharedPreferences) ?? DateTime(0);

    if (lastUpdatedRemote != null && lastUpdatedRemote.isAfter(lastUpdatedLocal)) {
      File databaseFile = File(join(await getDatabasesPath(), 'pokemon_database.db'));
      SharedPreferencesService.write('lastUpdated', lastUpdatedRemote.toIso8601String());
      await _storageRefPokemonDatabase.writeToFile(databaseFile);
    }
  }

  static Future<List<Pokemon>> fetchPokemons(int pageKey, int pageSize, String? search, String? type, String? owned,
      List<int>? ownedPokemon) async {
    Database database = await openDatabase(join(await getDatabasesPath(), 'pokemon_database.db'));
    String? where = '';
    List<dynamic>? whereArgs = [];

    if (search != null && search.trimLeft().trimRight().isNotEmpty) {
      search = search.toLowerCase().trimLeft().trimRight();
      where = 'name LIKE ?';
      whereArgs.add('%$search%');
    }

    if (type != null && type != 'all') {
      where += where == '' ? 'type = ?' : ' AND type = ?';
      whereArgs.add(type);
    }

    if (owned != null && owned != 'all' && ownedPokemon != null && ownedPokemon.isNotEmpty) {
      switch (owned) {
        case 'locked':
          where += where == '' ? 'id NOT IN (${ownedPokemon.join(',')})' : ' AND id NOT IN (${ownedPokemon.join(',')})';
          break;
        case 'unlocked':
          where += where == '' ? 'id IN (${ownedPokemon.join(',')})' : ' AND id IN (${ownedPokemon.join(',')})';
          break;
      }
    }

    if (where.isEmpty) {
      where = null;
      whereArgs = null;
    }

    List<Map<String, dynamic>> pokemons = await database.query('pokemon', where: where, whereArgs: whereArgs,
        limit: pageSize, offset: pageKey - 1);
    await database.close();
    return pokemons.map((pokemon) => Pokemon.fromDatabase(pokemon)).toList();
  }

  static Future<Pokemon> fetchPokemon(int id) async {
    Database database = await openDatabase(join(await getDatabasesPath(), 'pokemon_database.db'));
    List<Map<String, dynamic>> pokemons = await database.query('pokemon', where: 'id = ?', whereArgs: [id]);
    await database.close();
    return Pokemon.fromDatabase(pokemons.first);
  }

  static int getRandomPokemonId() {
    final random = Random();
    return random.nextInt(1025) + 1;
  }

  static Future<Pokemon?> getDailyPokemon() async {
    AppUser? appUser = await AppUserService.getUser();
    String formattedDate = getFormattedDate();
    if (appUser!.dailyPokemonDate == formattedDate) return null;

    int randomId = getRandomPokemonId();
    Pokemon pokemon = await fetchPokemon(randomId);

    appUser.dailyPokemonDate = formattedDate;
    appUser.dailyPokemonId = randomId;
    appUser.pokemons['${pokemon.id}'] = formattedDate;
    await AppUserService.updateUser(appUser);
    return pokemon;
  }
}