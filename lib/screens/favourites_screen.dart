import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';
import '../widgets/movie_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Movie> favoriteMovies;

  const FavoritesScreen({Key? key, required this.favoriteMovies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          return MovieCard(favoriteMovies[index]);
        },
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
              label: const Text('Clear All Movies'),
              onPressed: () {
                SharedPreferences.getInstance().then((value) => value.clear());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear)),
        ],
      ),
    );
  }
}
