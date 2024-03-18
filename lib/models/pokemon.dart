class Pokemon {
  final String name;
  final String imageUrl;
  final String? type;
  final String? description;

  Pokemon({
    required this.name,
    required this.imageUrl,
    this.type,
    this.description,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      type: json['types'][0]['type']['name'],
      description: json['species']['url'],
    );
  }

  @override
  String toString() {
    return 'Pokemon{name: $name, imageUrl: $imageUrl, type: $type, description: $description}';
  }
}
