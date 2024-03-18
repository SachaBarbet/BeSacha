import 'package:cloud_firestore/cloud_firestore.dart';

class Pokemon {
  final DocumentSnapshot? snapshot;
  final int id;
  final String name;
  final String imageUrl;
  final String type;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    this.snapshot,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
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
      imageUrl: data?['imageUrl'],
      type: data?['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'Pokemon{id:$id, name: $name, imageUrl: $imageUrl, type: $type}';
  }
}
