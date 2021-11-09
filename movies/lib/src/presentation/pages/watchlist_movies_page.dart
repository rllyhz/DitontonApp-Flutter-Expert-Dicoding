import 'package:core_app/core_app.dart'
    show ContentCardList, DrawerItem, RequestState, kBodyText, watchlistMovieEmptyMessage;
import 'package:flutter/material.dart';
import 'package:movies/src/presentation/pages/movie_detail_page.dart';
import 'package:movies/src/presentation/provider/watchlist_movie_notifier.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.loaded) {
            if (data.watchlistMovies.isEmpty) {
              return Center(
                child: Text(watchlistMovieEmptyMessage, style: kBodyText),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];

                return ContentCardList(
                  activeDrawerItem: DrawerItem.movie,
                  routeName: MovieDetailPage.routeName,
                  movie: movie,
                );
              },
              itemCount: data.watchlistMovies.length,
            );
          } else {
            return Center(
              key: const Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}
