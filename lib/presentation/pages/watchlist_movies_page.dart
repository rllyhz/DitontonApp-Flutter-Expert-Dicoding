import 'package:core_app/core_app.dart'
    show RequestState, DrawerItem, watchlistMovieEmptyMessage, kBodyText;
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/content_card_list.dart';
import 'package:flutter/material.dart';
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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.loaded) {
            if (data.watchlistMovies.isEmpty)
              return Center(
                child: Text(watchlistMovieEmptyMessage, style: kBodyText),
              );

            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];

                return ContentCardList(
                  activeDrawerItem: DrawerItem.movie,
                  routeName: MovieDetailPage.ROUTE_NAME,
                  movie: movie,
                );
              },
              itemCount: data.watchlistMovies.length,
            );
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}
