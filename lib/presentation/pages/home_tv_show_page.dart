import 'package:core_app/core_app.dart'
    show CardImageFull, DrawerItem, RequestState, SubHeading, TVShow, failedToFetchDataMessage, kHeading6, nowPlayingHeadingText, popularHeadingText, topRatedHeadingText;
import 'package:ditonton/presentation/pages/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTVShowPage extends StatefulWidget {
  @override
  _HomeTVShowPageState createState() => _HomeTVShowPageState();
}

class _HomeTVShowPageState extends State<HomeTVShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<TVShowListNotifier>(context, listen: false)
          ..fetchNowPlayingTVShows()
          ..fetchPopularTVShows()
          ..fetchTopRatedTVShows());
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
            Consumer<TVShowListNotifier>(builder: (context, data, child) {
              final state = data.nowPlayingState;
              if (state == RequestState.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.loaded) {
                return TVShowList(data.nowPlayingTVShows);
              } else {
                return Text(failedToFetchDataMessage);
              }
            }),
            SizedBox(height: 8.0),
            SubHeading(
              title: popularHeadingText,
              onTap: () =>
                  Navigator.pushNamed(context, PopularTVShowsPage.ROUTE_NAME),
            ),
            Consumer<TVShowListNotifier>(builder: (context, data, child) {
              final state = data.popularTVShowsState;
              if (state == RequestState.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.loaded) {
                return TVShowList(data.popularTVShows);
              } else {
                return Text(failedToFetchDataMessage);
              }
            }),
            SubHeading(
              title: topRatedHeadingText,
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTVShowsPage.ROUTE_NAME),
            ),
            SizedBox(height: 8.0),
            Consumer<TVShowListNotifier>(builder: (context, data, child) {
              final state = data.topRatedTVShowsState;
              if (state == RequestState.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.loaded) {
                return TVShowList(data.topRatedTVShows);
              } else {
                return Text(failedToFetchDataMessage);
              }
            }),
          ],
        ),
      ),
    );
  }
}

class TVShowList extends StatelessWidget {
  final List<TVShow> tvShows;

  TVShowList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final _tvShow = tvShows[index];
          return CardImageFull(
            activeDrawerItem: DrawerItem.tvShow,
            routeNameDestination: TVShowDetailPage.ROUTE_NAME,
            tvShow: _tvShow,
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
