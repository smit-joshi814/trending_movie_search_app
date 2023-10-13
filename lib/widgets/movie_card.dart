import 'package:flutter/material.dart';
import 'package:movie_app/services/favourits_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;

  const MovieCard(this.movie, {super.key});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool favourite = false;

  @override
  void initState() {
    super.initState();
    toggleFavoriteStatus(widget.movie, search: true).then((value) {
      setState(() {
        favourite = value;
      });
    });
  }

  Future<bool> toggleFavoriteStatus(Movie movie, {bool search = false}) async {
    final favoritesManager =
        FavoritesManager(await SharedPreferences.getInstance());
    if (search) {
      favourite = await favoritesManager.isContains(movie);
    } else {
      final List<Movie> favoriteMovies =
          await favoritesManager.getFavoriteMovies();
      if (await favoritesManager.isContains(movie)) {
        favoritesManager.removeFavoriteMovie(movie);
        favourite = false;
      } else {
        favoritesManager.addFavoriteMovie(movie);
        favourite = true;
      }
      setState(() {
        favoritesManager.isContains(movie).then((value) =>
            value ? favoriteMovies.remove(movie) : favoriteMovies.add(movie));
        favourite;
      });
    }
    // print(favourite);
    return favourite;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.network(
                  widget.movie.posterPath,
                  height: 140,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
                Container(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(height: 5),
                      Text(widget.movie.title),
                      Container(height: 5),
                      Text('Year: ${widget.movie.releaseYear}'),
                      Container(height: 10),
                      Text('IMDb: ${widget.movie.imdbRating}'),
                      TextButton.icon(
                        label: favourite
                            ? const Text('Remove From favourits')
                            : const Text('Add To Favourite'),
                        onPressed: () async {
                          toggleFavoriteStatus(widget.movie);
                        },
                        icon: Icon(
                          favourite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
