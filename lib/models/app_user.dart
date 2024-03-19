import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  late String email;
  late String username;
  late String displayName;
  late List<String>? friends;
  late List<int>? pokemons;

  AppUser({required this.uid, required this.email, required this.username, required this.displayName, this.friends, this.pokemons});

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
      friends: List<String>.from(data?['friends'] ?? []),
      pokemons: List<int>.from(data?['pokemons'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'display_name': displayName,
      'friends': friends ?? [],
      'pokemons': pokemons ?? [],
    };
  }
}