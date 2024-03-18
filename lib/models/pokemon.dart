import 'package:cloud_firestore/cloud_firestore.dart';

class Pokemon {
  final DocumentSnapshot? snapshot;
  final int id;
  final String name;
  final String defaultSprite;
  final String? shinySprite;
  final String type;

  Pokemon({
    required this.id,
    required this.name,
    required this.defaultSprite,
    required this.type,
    required this.shinySprite,
    this.snapshot,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      defaultSprite: json['sprites']['front_default'],
      shinySprite: json['sprites']['front_shiny'],
      type: json['types'][0]['type']['name'],
    );
  }

  factory Pokemon.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    Map<String, dynamic>? data = snapshot.data();
    return Pokemon(
      id: data?['id'],
      name: data?['name'],
      defaultSprite: data?['imageUrl'],
      shinySprite: data?['shinySprite'],
      type: data?['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'default_sprite': defaultSprite,
      'type': type,
      'shiny_sprite': shinySprite,
    };
  }

  @override
  String toString() {
    return 'Pokemon{id:$id, name: $name, imageUrl: $defaultSprite, type: $type}';
  }
}
