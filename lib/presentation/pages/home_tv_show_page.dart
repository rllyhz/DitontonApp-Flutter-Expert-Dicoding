import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/drawer_item_enum.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:ditonton/presentation/widgets/card_image_full.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
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
              'Now Playing',
              style: kHeading6,
            ),
            Consumer<TVShowListNotifier>(builder: (context, data, child) {
              final state = data.nowPlayingState;
              if (state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TVShowList(data.nowPlayingTVShows);
              } else {
                return Text('Failed');
              }
            }),
            SubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, "PopularTVShowsPage.ROUTE_NAME"),
            ),
            Consumer<TVShowListNotifier>(builder: (context, data, child) {
              final state = data.popularTVShowsState;
              if (state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TVShowList(data.popularTVShows);
              } else {
                return Text('Failed');
              }
            }),
            SubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(
                  context, "TopRatedTVShowsPage.ROUTE_NAME"),
            ),
            Consumer<TVShowListNotifier>(builder: (context, data, child) {
              final state = data.topRatedTVShowsState;
              if (state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TVShowList(data.topRatedTVShows);
              } else {
                return Text('Failed');
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
            activeDrawerItem: DrawerItem.TVShow,
            routeNameDestination: TVShowDetailPage.ROUTE_NAME,
            tvShow: _tvShow,
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
