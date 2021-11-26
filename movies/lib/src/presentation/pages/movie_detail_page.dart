import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_app/core_app.dart'
    show
        MovieDetail,
        ScrollableSheetContainer,
        baseImageUrl,
        failedToFetchDataMessage,
        getFormattedDuration,
        getFormattedGenres,
        kHeading5,
        kHeading6,
        kMikadoYellow,
        watchlistAddSuccessMessage,
        watchlistRemoveSuccessMessage;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/src/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movies/src/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:movies/src/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
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
      context.read<MovieDetailBloc>().add(OnMovieDetailCalled(widget.id));
      context
          .read<MovieRecommendationsBloc>()
          .add(OnMovieRecommendationsCalled(widget.id));
      context.read<WatchlistMoviesBloc>().add(FetchWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMovieAddedToWatchlist = context.select<WatchlistMoviesBloc, bool>(
        (bloc) {
          if (bloc.state is MovieIsAddedToWatchlist) {
            return (bloc.state as MovieIsAddedToWatchlist).isAdded;
          }
          return false;
        });

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          key: const Key('movie_content'),
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieDetailHasData) {
              final movie = state.result;
              return DetailContent(
                movie: movie,
                isMovieAddedToWatchlist: isMovieAddedToWatchlist,
              );
            } else {
              return const Center(
                child: Text(failedToFetchDataMessage),
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final bool isMovieAddedToWatchlist;
  final MovieDetail movie;

  const DetailContent(
      {required this.movie, required this.isMovieAddedToWatchlist});

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
            if (!isMovieAddedToWatchlist) {
              context
                  .read<WatchlistMoviesBloc>()
                  .add(AddMovieToWatchlist(movie));
            } else {
              context.read<WatchlistMoviesBloc>().add(
                  RemoveMovieFromWatchlist(movie));
            }

            final message = context.select<WatchlistMoviesBloc, String>((value) {
              if (value.state is MovieIsAddedToWatchlist) {
                final isAdded = (value.state as MovieIsAddedToWatchlist).isAdded;
                return isAdded ? watchlistAddSuccessMessage : watchlistRemoveSuccessMessage;
              } else {
                return !isMovieAddedToWatchlist ? watchlistAddSuccessMessage : watchlistRemoveSuccessMessage;
              }
            });

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
              context.select<WatchlistMoviesBloc, bool>(
                  (bloc) {
                if (bloc.state is MovieIsAddedToWatchlist) {
                  return (bloc.state as MovieIsAddedToWatchlist).isAdded;
                }
                return false;
              })
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
        BlocBuilder<MovieRecommendationsBloc, MovieRecommendationsState>(
          key: const Key('recommendation_movie'),
          builder: (context, state) {
            if (state is MovieRecommendationsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieRecommendationsHasData) {
              final recommendationMovies = state.result;

              return Container(
                margin: const EdgeInsets.only(top: 8.0),
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final movieRecoms = recommendationMovies[index];
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
                            placeholder: (context, url) =>
                            const Padding(
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
                  itemCount: recommendationMovies.length,
                ),
              );
            } else if (state is MovieRecommendationsEmpty) {
              return const Text('-');
            } else {
              return const Text(failedToFetchDataMessage);
            }
          },
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
