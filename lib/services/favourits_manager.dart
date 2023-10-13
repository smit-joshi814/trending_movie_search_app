import 'dart:convert';

import 'package:movie_app/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  final SharedPreferences prefs;

  FavoritesManager(this.prefs);

  Future<List<Movie>> getFavoriteMovies() async {
    final favoritesJson = prefs.getStringList('favorite_movies') ?? [];
    final List<Movie> favoriteMovies = [];
    for (final jsonStr in favoritesJson) {
      final movieMap = jsonDecode(jsonStr);
      final movie = Movie.fromJson(movieMap);

      favoriteMovies.add(movie);
    }

    return favoriteMovies;
  }

  Future<void> addFavoriteMovie(Movie movie) async {
    final favoritesJson = prefs.getStringList('favorite_movies') ?? [];
    favoritesJson.add(json.encode(movie.toJson()));
    await prefs.setStringList('favorite_movies', favoritesJson);
    // print('Movie Saved In Favourits');
  }

  Future<void> removeFavoriteMovie(Movie movie) async {
    final favoritesJson = prefs.getStringList('favorite_movies') ?? [];
    favoritesJson.remove(json.encode(movie.toJson()));
    await prefs.setStringList('favorite_movies', favoritesJson);
  }

  Future<bool> isContains(Movie movie) async {
    final List<Movie> favouriteMovies = await getFavoriteMovies();
    bool ismoviePresent =
        favouriteMovies.any((element) => element.id == movie.id);
    return ismoviePresent;
  }

  void clearFavouriteMovies() {
    prefs.clear();
  }
}
