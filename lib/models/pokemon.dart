class Pokemon {
  final int ID;
  final String name;
  final String imageUrl;
  final String? type;
  final String? description;

  Pokemon({
    required this.ID,
    required this.name,
    required this.imageUrl,
    this.type,
    this.description,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      ID: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      type: json['types'][0]['type']['name'],
      description: json['species']['url'],
    );
  }

  @override
  String toString() {
    return 'Pokemon{id:$ID, name: $name, imageUrl: $imageUrl, type: $type, description: $description}';
  }
}
