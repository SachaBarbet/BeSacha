import 'package:flutter/material.dart';

class PokedexPage extends StatelessWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}

//
// class PokedexPage extends StatelessWidget {
//   final Pokemon pokemon;
//
//   const PokedexPage({Key? key, required this.pokemon}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pokedex'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(pokemon.imageUrl),
//             Text(
//               'Pokémon de jour: ${pokemon.name}',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text('Type: ${pokemon.type}'),
//           ],
//         ),
//       ),
//     );
//   }
// }
