import 'package:core_app/core_app.dart'
    show CardImageFull, DrawerItem, Movie, RequestState, SubHeading, failedToFetchDataMessage, kHeading6, nowPlayingHeadingText, popularHeadingText, topRatedHeadingText;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movies/src/presentation/pages/movie_detail_page.dart';
import 'package:movies/src/presentation/pages/popular_movies_page.dart';
import 'package:movies/src/presentation/pages/top_rated_movies_page.dart';
import 'package:movies/src/presentation/provider/movie_list_notifier.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nowPlayingHeadingText,
              style: kHeading6,
            ),
            Consumer<MovieListNotifier>(builder: (context, data, child) {
              final state = data.nowPlayingState;
              if (state == RequestState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.loaded) {
                return MovieList(data.nowPlayingMovies);
              } else {
                return const Text(failedToFetchDataMessage);
              }
            }),
            const SizedBox(height: 8.0),
            SubHeading(
              title: popularHeadingText,
              onTap: () =>
                  Navigator.pushNamed(context, PopularMoviesPage.routeName),
            ),
            Consumer<MovieListNotifier>(builder: (context, data, child) {
              final state = data.popularMoviesState;
              if (state == RequestState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.loaded) {
                return MovieList(data.popularMovies);
              } else {
                return const Text(failedToFetchDataMessage);
              }
            }),
            const SizedBox(height: 8.0),
            SubHeading(
              title: topRatedHeadingText,
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedMoviesPage.routeName),
            ),
            Consumer<MovieListNotifier>(builder: (context, data, child) {
              final state = data.topRatedMoviesState;
              if (state == RequestState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.loaded) {
                return MovieList(data.topRatedMovies);
              } else {
                return const Text(failedToFetchDataMessage);
              }
            }),
          ],
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return CardImageFull(
            activeDrawerItem: DrawerItem.movie,
            routeNameDestination: MovieDetailPage.routeName,
            movie: movie,
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
