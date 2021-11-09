import 'package:core_app/core_app.dart' show ContentCardList, DrawerItem, RequestState;
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_shows_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tvshow';

  @override
  _TopRatedTVShowsPageState createState() => _TopRatedTVShowsPageState();
}

class _TopRatedTVShowsPageState extends State<TopRatedTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedTVShowsNotifier>(context, listen: false)
            .fetchTopRatedTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TVShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTVShowsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = data.tvShows[index];

                  return ContentCardList(
                    activeDrawerItem: DrawerItem.tvShow,
                    routeName: TVShowDetailPage.ROUTE_NAME,
                    tvShow: tvShow,
                  );
                },
                itemCount: data.tvShows.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
