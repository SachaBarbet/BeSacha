import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  late String email;
  late String username;
  late String displayName;
  late DateTime dailyPokemonDate;
  late List<int>? pokemons;
  late List<String>? friends;

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
    DateTime? dailyDate;
    if (data != null) {
      int? dailyDateInt = data['daily_pokemon_date'];
      if (dailyDateInt != null) {
        print('first log : $dailyDateInt');
        dailyDate = DateTime.fromMillisecondsSinceEpoch(dailyDateInt);
        print(dailyDate);
      }
    }
    return AppUser(
      uid: snapshot.id,
      email: data?['email'],
      username: data?['username'],
      displayName: data?['display_name'],
      friends: List<String>.from(data?['friends'] ?? []),
      pokemons: List<int>.from(data?['pokemons'] ?? []),
      dailyPokemonDate: dailyDate ?? DateTime.now().add(const Duration(days: -1)),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'display_name': displayName,
      'friends': friends,
      'daily_pokemon_date': dailyPokemonDate.millisecondsSinceEpoch,
      'pokemons': pokemons,
    };
  }
}
