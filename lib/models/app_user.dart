import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  late String email;
  late String username;
  late String displayName;
  late String dailyPokemonDate;
  late int dailyPokemonId;
  late Map<int, String> pokemons;
  late List<String> friends;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.displayName,
    required this.dailyPokemonDate,
    required this.pokemons,
    required this.friends,
  });

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data();
    return AppUser(
      uid: snapshot.id,
      email: data?['email'],
      username: data?['username'],
      displayName: data?['display_name'],
      friends: data?['friends'],
      pokemons: data?['pokemons'],
      dailyPokemonDate: data?['dailyPokemonDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'display_name': displayName,
      'friends': friends,
      'daily_pokemon_date': dailyPokemonDate,
      'pokemons': pokemons,
    };
  }
}
