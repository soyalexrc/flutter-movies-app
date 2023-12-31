import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/utils/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoading = StreamController.broadcast();
  Timer? _debounceTimer;

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  void clearStreams() {
    debounceMovies.close();
    isLoading.close();
  }

  void _onQueryChanged(String query) {
    isLoading.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();


    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      debounceMovies.add(movies);
      initialMovies = movies;
      isLoading.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
        initialData: initialMovies,
        stream: debounceMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieSearchItem(
                  movie: movies[index],
                  onMovieSelected: (context, movie) {
                    clearStreams();
                    close(context, movie);
                  },
                );
              });
        });
  }

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoading.stream,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return  SpinPerfect(
                spins: 10,
                infinite: true,
                duration: const Duration(seconds: 20),
                child: IconButton(
                    onPressed: () => query = '', icon: Icon(Icons.refresh_rounded)),
              );
            } else {
              return FadeIn(
                animate: query.isNotEmpty,
                duration: const Duration(microseconds: 500),
                child: IconButton(
                    onPressed: () => query = '', icon: Icon(Icons.clear)),
              );
            }
          }),



      // FadeIn(
      //   animate: query.isNotEmpty,
      //   duration: const Duration(microseconds: 500),
      //   child: IconButton(onPressed: () => query = '', icon: Icon(Icons.clear)),
      // ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return buildResultsAndSuggestions();
  }
}

class MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const MovieSearchItem(
      {super.key, required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                  width: size.width * 0.2,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        movie.posterPath,
                        loadingBuilder: (context, child, loadingProgress) {
                          return FadeIn(child: child);
                        },
                      ))),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyles.titleMedium),
                    (movie.overview.length > 100)
                        ? Text('${movie.overview.substring(0, 100)}...')
                        : Text(movie.overview),
                    Row(
                      children: [
                        Icon(Icons.star_half_rounded,
                            color: Colors.yellow.shade800),
                        Text(
                            HumanFormats.number(movie.voteAverage, decimals: 1),
                            style: textStyles.bodyMedium
                                ?.copyWith(color: Colors.yellow.shade900))
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
