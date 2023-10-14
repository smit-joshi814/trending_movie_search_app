import 'package:flutter/material.dart';
import 'package:movie_app/screens/favourites_screen.dart';
import 'package:movie_app/screens/search_screen.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/movie.dart';

import '../services/favourits_manager.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  final FavoritesManager favoritesManager;
  const HomeScreen({Key? key, required this.favoritesManager})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 1);

  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    widget.favoritesManager
        .getFavoriteMovies()
        .then((value) => favoriteMovies = value);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newMovies = await fetchTopRatedMovies(page: pageKey);
      if (newMovies.isNotEmpty) {
        final isLastPage = newMovies.length < 6; // Define the pageSize
        if (isLastPage) {
          _pagingController.appendLastPage(newMovies);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newMovies, nextPageKey);
        }
      } else {
        _pagingController.appendLastPage([]);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
        leading: IconButton(
          tooltip: 'Favorites',
          onPressed: () {
            widget.favoritesManager
                .getFavoriteMovies()
                .then((value) => favoriteMovies = value);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FavoritesScreen(favoriteMovies: favoriteMovies),
              ),
            );
          },
          icon: const Icon(Icons.favorite_outline),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Movies',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: PagedListView<int, Movie>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Movie>(
          animateTransitions: true,
          transitionDuration: const Duration(seconds: 2),
          itemBuilder: (context, movie, index) {
            return MovieCard(movie);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
