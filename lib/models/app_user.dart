import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  late String? uid;
  late String? email;
  late String? username;
  late String? displayName;
  late List<String>? friends;
  late DateTime? dailyPokemonDate;
  late List<String>? pokemons;

  AppUser({this.uid, this.email, this.username, this.displayName, this.friends, this.dailyPokemonDate, this.pokemons});

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    Map<String, dynamic>? data = snapshot.data();
    DateTime? dailyDate;
    if (data != null) {
      String? dailyDateString = data['daily_pokemon_date'];
      if (dailyDateString != null) {

        print('first log : $dailyDateString');
        dailyDate = DateTime.tryParse(dailyDateString);
        if (dailyDate == null) print('Daily date null');
        else print(dailyDate.toString());
      }
    }
    return AppUser(
      email: data?['email'],
      username: data?['username'],
      displayName: data?['display_name'],
      friends: List<String>.from(data?['friends'] ?? []),
      dailyPokemonDate: dailyDate ?? DateTime.now(),
      pokemons: List<String>.from(data?['pokemons'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'display_name': displayName,
      'friends': friends ?? [],
      'daily_pokemon_date': dailyPokemonDate.toString(),
      'pokemons': pokemons,
    };
  }
}