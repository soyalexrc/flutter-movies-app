import 'package:cinemapedia/presentation/delegates/search_movie_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/initial_loading_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _HomeView(),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
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
            Icon(Icons.movie_outlined, color: colors.primary,),
            const SizedBox(width: 5,),
            Text('Cinemapedia', style: textStyle,),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                final movieRepository = ref.read(movieRepositoryProvider);

                showSearch(
                    context: context,
                    delegate: SearchMovieDelegate(searchMovies: movieRepository.searchMovies));
              },
              icon: Icon(Icons.search))
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
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
              ),

              MovieHorizontalListView(
                  movies: upcoming,
                  title: 'Proximamente',
                  badge: 'En este mes',
                  loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage()
              ),

              MovieHorizontalListView(
                  movies: popular,
                  title: 'Populares',
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage()
              ),
              MovieHorizontalListView(
                  movies: topRated,
                  title: 'Mejor Calificadas',
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage()
              ),
              const SizedBox(height: 50,)
            ],
          );
        },
      ))
    ]);
  }
}
