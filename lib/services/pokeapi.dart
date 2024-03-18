import 'package:be_sacha/services/app_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pokemon.dart';

class PokeApi {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  static Future<List<Pokemon>> fetchPokemons(int pageKey, int pageSize, [Pokemon? pokemon, String? search]) async {
    late final QuerySnapshot<Pokemon> pokemonsQuery;
    if (pokemon != null && pokemon.snapshot != null && search != null && search.isNotEmpty) {
      pokemonsQuery = await AppFirebase.pokemonCollectionRef.startAfterDocument(pokemon.snapshot!)
        .limit(pageSize).get();
    } else {
      pokemonsQuery = await AppFirebase.pokemonCollectionRef.limit(pageSize).get();
    }


    return pokemonsQuery.docs.map((doc) => doc.data()).toList();
  }
}
