import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

  @override
  void initState() {
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites')
      ),
      body: MovieMasonry(movies: favoriteMovies, loadNextPage: () {},)
    );
  }
}
