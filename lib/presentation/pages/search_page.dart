import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/drawer_item_enum.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/widgets/content_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  SearchPage({
    Key? key,
    required this.activeDrawerItem,
  }) : super(key: key);

  final DrawerItem activeDrawerItem;
  late bool _isAlreadySearched = false;
  late String _title;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchNotifier>(context);
    _title = activeDrawerItem == DrawerItem.Movie ? "Movie" : "TV Show";

    return Scaffold(
      appBar: AppBar(
        title: Text('Search $_title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                _isAlreadySearched = true;

                if (activeDrawerItem == DrawerItem.Movie)
                  provider.fetchMovieSearch(query);
                else
                  provider.fetchTVShowSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchNotifier>(
      builder: (ctx, data, child) {
        if (data.state == RequestState.Loading) {
          return Container(
            margin: EdgeInsets.only(top: 32.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (data.state == RequestState.Loaded) {
          if (activeDrawerItem == DrawerItem.Movie)
            return _buildMovieCardList(data.moviesSearchResult);
          else
            return _buildTVShowCardList(data.tvShowsSearchResult);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMovieCardList(List<Movie> movies) {
    if (_isAlreadySearched && movies.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 32.0),
        child: Center(
          child: Text('$_title\s not found!'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ContentCardList(
            movie: movie,
            activeDrawerItem: activeDrawerItem,
          );
        },
        itemCount: movies.length,
      ),
    );
  }

  Widget _buildTVShowCardList(List<TVShow> tvShows) {
    if (_isAlreadySearched && tvShows.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 32.0),
        child: Center(
          child: Text('$_title\s not found!'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return ContentCardList(
            tvShow: tvShow,
            activeDrawerItem: activeDrawerItem,
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
