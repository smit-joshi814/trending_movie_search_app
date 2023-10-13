import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie>? filteredMovies = [];
  bool filterByYear = false;
  bool filterByPopularity = false;
  bool filterByImdb = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) async {
            filteredMovies = await searchMovies(value);
            setState(() {
              filteredMovies;
            });
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Sort movies by year.
                    sortMoviesByYear();
                  },
                  child: const Text('Sort by Year'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Sort movies by popularity.
                    sortMoviesByPopularity();
                  },
                  child: const Text('Sort by Popularity'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Sort movies by IMDb rating.
                    sortMoviesByImdbRating();
                  },
                  child: const Text('Sort by IMDB Rating'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMovies!.length,
              itemBuilder: (context, index) {
                return MovieCard(filteredMovies![index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void sortMoviesByYear() {
    setState(() {
      filterByYear
          ? filteredMovies!
              .sort((b, a) => a.releaseYear.compareTo(b.releaseYear))
          : filteredMovies!
              .sort((a, b) => a.releaseYear.compareTo(b.releaseYear));
      filterByYear = filterByYear ? false : true;
    });
  }

  void sortMoviesByPopularity() {
    setState(() {
      filterByPopularity
          ? filteredMovies!.sort((b, a) => a.popularity.compareTo(b.popularity))
          : filteredMovies!
              .sort((a, b) => a.popularity.compareTo(b.popularity));
      filterByPopularity = filterByPopularity ? false : true;
    });
  }

  void sortMoviesByImdbRating() {
    setState(() {
      filterByImdb
          ? filteredMovies!.sort((b, a) => a.imdbRating.compareTo(b.imdbRating))
          : filteredMovies!
              .sort((a, b) => a.imdbRating.compareTo(b.imdbRating));
      filterByImdb = filterByImdb ? false : true;
    });
  }
}
