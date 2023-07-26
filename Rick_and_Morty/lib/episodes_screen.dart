import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Required to convert the API response from JSON

class EpisodesScreen extends StatelessWidget {
  final int id;

  const EpisodesScreen({super.key, required this.id});

  Future<List<String>> fetchEpisodes(int characterId) async {
    try {
      final response = await http.get(
          Uri.parse('https://rickandmortyapi.com/api/character/$characterId'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> episodesList = jsonData['episode'];
        final List<String> episodeNames = [];

        for (var episodeUrl in episodesList) {
          final episodeResponse = await http.get(Uri.parse(episodeUrl));
          if (episodeResponse.statusCode == 200) {
            final episodeData = jsonDecode(episodeResponse.body);
            episodeNames.add(episodeData['name']);
          }
        }
        return episodeNames;
      } else {
        throw Exception(
            'Failed to load episodes for character with id: $characterId');
      }
    } catch (error) {
      if (kDebugMode) {
        print('error caught: $error');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodes for Character $id'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchEpisodes(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                );
              },
            );
          } else {
            return Center(
              child: Text('No episodes found for character with id: $id'),
            );
          }
        },
      ),
    );
  }
}
