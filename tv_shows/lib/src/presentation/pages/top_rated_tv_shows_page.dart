import 'package:core_app/core_app.dart'
    show ContentCardList, DrawerItem, RequestState;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/src/presentation/pages/tv_show_detail_page.dart';
import 'package:tv_shows/src/presentation/provider/top_rated_tv_shows_notifier.dart';

class TopRatedTVShowsPage extends StatefulWidget {
  static const routeName = '/top-rated-tvshow';

  const TopRatedTVShowsPage({Key? key}) : super(key: key);

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
        title: const Text('Top Rated TVShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTVShowsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = data.tvShows[index];

                  return ContentCardList(
                    activeDrawerItem: DrawerItem.tvShow,
                    routeName: TVShowDetailPage.routeName,
                    tvShow: tvShow,
                  );
                },
                itemCount: data.tvShows.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
