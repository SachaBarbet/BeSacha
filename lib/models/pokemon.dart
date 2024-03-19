class Pokemon {
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

  factory Pokemon.fromDatabase(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      defaultSprite: json['default_sprite'],
      shinySprite: json['shiny_sprite'],
      type: json['type'],
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
