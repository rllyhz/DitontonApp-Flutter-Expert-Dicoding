import 'package:core_app/core_app.dart'
    show ContentCardList, DrawerItem, RequestState;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/src/presentation/pages/tv_show_detail_page.dart';
import 'package:tv_shows/src/presentation/provider/popular_tv_shows_notifier.dart';

class PopularTVShowsPage extends StatefulWidget {
  static const routeName = '/popular-tvshow';

  const PopularTVShowsPage({Key? key}) : super(key: key);

  @override
  _PopularTVShowsPageState createState() => _PopularTVShowsPageState();
}

class _PopularTVShowsPageState extends State<PopularTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularTVShowsNotifier>(context, listen: false)
            .fetchPopularTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TVShows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTVShowsNotifier>(
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
