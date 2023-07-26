import 'package:flutter/material.dart';
import 'episodes_screen.dart';
import 'models.dart';

class CharacterTile extends StatelessWidget {
  final Character character;

  const CharacterTile({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(
          character.name,
          textAlign: TextAlign.center,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodesScreen(id: character.id),
            ),
          );
        },
        child: Image.network(
          character.img,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
