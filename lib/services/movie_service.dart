import 'dart:convert';

import 'package:movie_app/utils/app_constants.dart';

import '../models/movie.dart';
import 'package:http/http.dart' as http;

Future<List<Movie>> fetchTopRatedMovies({int page = 1}) async {
  final response = await http.get(
      Uri.parse(
          '${AppConstants.baseURL}trending/movie/day?page=$page&api_key=${AppConstants.apiKey}'),
      headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    List<Movie> movies = parseMovies(response.body);
    return movies;
  } else {
    throw Exception('Failed to load top-rated movies');
  }
}

Future<List<Movie>> searchMovies(String value) async {
  final response = await http.get(
      Uri.parse(
          '${AppConstants.baseURL}search/movie?query=$value&page=1&include_adult=true&api_key=${AppConstants.apiKey}'),
      headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    List<Movie> movies = parseMovies(response.body);
    return movies;
  } else {
    throw Exception('Failed to load top-rated movies');
  }
}

List<Movie> parseMovies(String responseBody) {
  final parsed = json.decode(responseBody);

  if (parsed.containsKey('results')) {
    List<Movie> movies = List<Movie>.from(parsed['results'].map((movieData) {
      return Movie(
          title: movieData['title'],
          posterPath: '${AppConstants.posterPath}${movieData['poster_path']}',
          releaseYear: DateTime.parse(movieData['release_date']).year,
          imdbRating: (movieData['vote_average'] as double).toDouble(),
          popularity: (movieData['popularity'] as double).toDouble(),
          id: (movieData['id'] as int).toInt());
    }));
    return movies;
  } else {
    throw Exception('Failed to parse movies data.');
  }
}
