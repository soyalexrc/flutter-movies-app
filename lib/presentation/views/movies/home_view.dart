import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';
import '../../delegates/search_movie_movie_delegate.dart';
import '../../providers/movies/initial_loading_provider.dart';
import '../../providers/movies/movies_providers.dart';
import '../../providers/movies/movies_slideshow_provider.dart';
import '../../providers/search/search_movies_provider.dart';
import '../../widgets/movies/movie_horizontal_listview.dart';
import '../../widgets/movies/movies_slideshow.dart';
import '../../widgets/shared/full_screen_loader.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.titleMedium;

    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) return const FullScreenloader();

    final nowPlaying = ref.watch(nowPlayingMoviesProvider);
    final popular = ref.watch(popularMoviesProvider);
    final topRated = ref.watch(topRatedMoviesProvider);
    final upcoming = ref.watch(upcomingMoviesProvider);
    final slideshowMovies = ref.watch(moviesSlideshowProvider);

    return CustomScrollView(slivers: [
      SliverAppBar(
        floating: true,

        title: Row(
          children: [
            Icon(
              Icons.movie_outlined,
              color: colors.primary,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Cinemapedia',
              style: textStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                final searchedMovies = ref.read(searchedMoviesProvider);
                final searchQuery = ref.read(searchQueryProvider);

                final movie = showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                        initialMovies: searchedMovies,
                        searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery ))
                    .then((movie) {
                  if (movie == null) return;
                  context.push('/home/0/movie/${movie.id}');
                });
              },
              icon: const Icon(Icons.search))
        ],
        // flexibleSpace: FlexibleSpaceBar(
        //   title: CustomAppbar(),
        // ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
                (context, index) {
              return Column(
                children: [
                  MoviesSlideshow(movies: slideshowMovies),
                  MovieHorizontalListView(
                      movies: nowPlaying,
                      title: 'En cines',
                      badge: 'Lunes 20',
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage()),
                  MovieHorizontalListView(
                      movies: upcoming,
                      title: 'Proximamente',
                      badge: 'En este mes',
                      loadNextPage: () =>
                          ref.read(upcomingMoviesProvider.notifier).loadNextPage()),
                  MovieHorizontalListView(
                      movies: popular,
                      title: 'Populares',
                      loadNextPage: () =>
                          ref.read(popularMoviesProvider.notifier).loadNextPage()),
                  MovieHorizontalListView(
                      movies: topRated,
                      title: 'Mejor Calificadas',
                      loadNextPage: () =>
                          ref.read(topRatedMoviesProvider.notifier).loadNextPage()),
                  const SizedBox(
                    height: 50,
                  )
                ],
              );
            },
          ))
    ]);
  }
}