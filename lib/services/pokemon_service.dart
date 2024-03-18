import 'dart:io';

import 'package:be_sacha/models/pokemon.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      print('Downloading the latest version of the Pokemon database...');
      File databaseFile = File(join(await getDatabasesPath(), 'pokemon_database.db'));
      SharedPreferencesService.write('lastUpdated', lastUpdatedRemote.toIso8601String());
      await _storageRefPokemonDatabase.writeToFile(databaseFile);
    }
  }

  static Future<List<Pokemon>> fetchPokemons(int pageKey, int pageSize) async {
    print('fetchPokemons pageKey: $pageKey, pageSize: $pageSize');
    Database database = await openDatabase(join(await getDatabasesPath(), 'pokemon_database.db'));
    print('fetchPokemons database: $database');
    List<Map<String, dynamic>> pokemons = await database.query('pokemon', limit: pageSize, offset: (pageKey - 1) * pageSize);
    print('fetchPokemons pokemons: $pokemons');
    await database.close();
    print('fetchPokemons database closed');
    return pokemons.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
  }
}