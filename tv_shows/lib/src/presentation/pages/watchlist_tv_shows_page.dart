import 'package:core_app/core_app.dart'
    show
        ContentCardList,
        DrawerItem,
        RequestState,
        kBodyText,
        watchlistTVShowEmptyMessage;
import 'package:tv_shows/src/presentation/provider/watchlist_tv_show_notifier.dart';
import 'tv_show_detail_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistTVShowsPage extends StatefulWidget {
  const WatchlistTVShowsPage({Key? key}) : super(key: key);

  @override
  _WatchlistTVShowsPageState createState() => _WatchlistTVShowsPageState();
}

class _WatchlistTVShowsPageState extends State<WatchlistTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistTVShowNotifier>(context, listen: false)
            .fetchWatchlistTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
      child: Consumer<WatchlistTVShowNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.loaded) {
            if (data.watchlistTVShows.isEmpty) {
              return Center(
                child: Text(watchlistTVShowEmptyMessage, style: kBodyText),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                final tvShow = data.watchlistTVShows[index];

                return ContentCardList(
                  activeDrawerItem: DrawerItem.tvShow,
                  routeName: TVShowDetailPage.routeName,
                  tvShow: tvShow,
                );
              },
              itemCount: data.watchlistTVShows.length,
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
