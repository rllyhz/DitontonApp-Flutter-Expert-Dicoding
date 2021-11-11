import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_app/core_app.dart'
    show
        MovieDetail,
        RequestState,
        ScrollableSheetContainer,
        baseImageUrl,
        getFormattedDuration,
        getFormattedGenres,
        kHeading5,
        kHeading6,
        kMikadoYellow,
        watchlistAddSuccessMessage,
        watchlistRemoveSuccessMessage;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/src/presentation/provider/movie_detail_notifier.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail-movie';

  const MovieDetailPage({required this.id});

  final int id;

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieDetailNotifier>(context, listen: false)
          .fetchMovieDetail(widget.id);
      Provider.of<MovieDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<MovieDetailNotifier>(
          builder: (context, provider, child) {
            if (provider.movieState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.movieState == RequestState.loaded) {
              final movie = provider.movie;
              return DetailContent(movie, provider);
            } else {
              return Center(
                child: Text(provider.message),
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final MovieDetailNotifier provider;

  DetailContent(this.movie, this.provider);

  @override
  Widget build(BuildContext context) {
    return ScrollableSheetContainer(
      backgroundUrl: '$baseImageUrl${movie.posterPath}',
      scrollableContents: [
        Text(
          movie.title,
          style: kHeading5,
        ),
        ElevatedButton(
          onPressed: () async {
            if (!provider.isAddedToWatchlist) {
              await provider.addWatchlist(movie);
            } else {
              await provider.removeFromWatchlist(movie);
            }

            final message = provider.watchlistMessage;

            if (message == watchlistAddSuccessMessage ||
                message == watchlistRemoveSuccessMessage) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(message),
                    );
                  });
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              provider.isAddedToWatchlist
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
              const SizedBox(width: 6.0),
              const Text('Watchlist'),
              const SizedBox(width: 4.0),
            ],
          ),
        ),
        Text(
          getFormattedGenres(movie.genres),
        ),
        Text(
          getFormattedDuration(movie.runtime),
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: movie.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: kMikadoYellow,
              ),
              itemSize: 24,
            ),
            Text('${movie.voteAverage}')
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Overview',
          style: kHeading6,
        ),
        Text(
          movie.overview.isNotEmpty ? movie.overview : "-",
        ),
        const SizedBox(height: 16),
        Text(
          'Recommendations',
          style: kHeading6,
        ),
        provider.movieRecommendations.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 8.0),
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final movieRecoms = provider.movieRecommendations[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            MovieDetailPage.routeName,
                            arguments: movieRecoms.id,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: '$baseImageUrl${movieRecoms.posterPath}',
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: provider.movieRecommendations.length,
                ),
              )
            : const Text('-'),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
