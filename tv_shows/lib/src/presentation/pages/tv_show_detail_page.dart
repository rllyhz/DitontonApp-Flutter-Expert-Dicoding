import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_app/core_app.dart'
    show
        ScrollableSheetContainer,
        TVShowDetail,
        baseImageUrl,
        failedToFetchDataMessage,
        getFormattedDurationFromList,
        getFormattedGenres,
        kGrey,
        kHeading5,
        kHeading6,
        kMikadoYellow,
        kRichBlack,
        watchlistAddSuccessMessage,
        watchlistRemoveSuccessMessage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/src/presentation/bloc/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:tv_shows/src/presentation/bloc/tv_show_recommendations/tv_show_recommendations_bloc.dart';
import 'package:tv_shows/src/presentation/bloc/watchlist_tv_shows/watchlist_tv_shows_bloc.dart';

class TVShowDetailPage extends StatefulWidget {
  static const routeName = '/detail-tvshow';

  const TVShowDetailPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _TVShowDetailPageState createState() => _TVShowDetailPageState();
}

class _TVShowDetailPageState extends State<TVShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVShowDetailBloc>().add(OnTVShowDetailCalled(widget.id));
      context
          .read<TVShowRecommendationsBloc>()
          .add(OnTVShowRecommendationsCalled(widget.id));
      context.read<WatchlistTVShowsBloc>().add(FetchWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTVShowAddedToWatchlist = context.select<WatchlistTVShowsBloc, bool>(
        (bloc) => (bloc.state is TVShowIsAddedToWatchlist)
            ? (bloc.state as TVShowIsAddedToWatchlist).isAdded
            : false);

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<TVShowDetailBloc, TVShowDetailState>(
          builder: (ctx, tvShowState) {
            if (tvShowState is TVShowDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (tvShowState is TVShowDetailHasData) {
              final tvShow = tvShowState.result;
              return DetailContent(
                tvShow: tvShow,
                isTVShowAddedToWatchlist: isTVShowAddedToWatchlist,
              );
            } else {
              return const Center(child: Text(failedToFetchDataMessage));
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final bool isTVShowAddedToWatchlist;
  final TVShowDetail tvShow;

  const DetailContent({
    Key? key,
    required this.tvShow,
    required this.isTVShowAddedToWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollableSheetContainer(
      backgroundUrl: '$baseImageUrl${tvShow.posterPath}',
      scrollableContents: [
        Text(
          tvShow.name,
          style: kHeading5,
        ),
        ElevatedButton(
          onPressed: () async {
            if (!isTVShowAddedToWatchlist) {
              context
                  .read<WatchlistTVShowsBloc>()
                  .add(AddTVShowToWatchlist(tvShow));
            } else {
              context
                  .read<WatchlistTVShowsBloc>()
                  .add(RemoveTVShowFromWatchlist(tvShow));
            }

            final message =
                context.select<WatchlistTVShowsBloc, String>((value) {
              if (value.state is TVShowIsAddedToWatchlist) {
                final isAdded =
                    (value.state as TVShowIsAddedToWatchlist).isAdded;
                return isAdded
                    ? watchlistAddSuccessMessage
                    : watchlistRemoveSuccessMessage;
              } else {
                return !isTVShowAddedToWatchlist
                    ? watchlistAddSuccessMessage
                    : watchlistRemoveSuccessMessage;
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
              isTVShowAddedToWatchlist
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
              const SizedBox(width: 6.0),
              const Text('Watchlist'),
              const SizedBox(width: 4.0),
            ],
          ),
        ),
        Text(
          getFormattedGenres(tvShow.genres),
        ),
        Text(
          tvShow.episodeRunTime.isNotEmpty
              ? getFormattedDurationFromList(tvShow.episodeRunTime)
              : 'N/A',
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: tvShow.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: kMikadoYellow,
              ),
              itemSize: 24,
            ),
            Text('${tvShow.voteAverage}')
          ],
        ),
        const SizedBox(height: 12.0),
        Text(
          'Total Episodes: ' + tvShow.numberOfEpisodes.toString(),
        ),
        Text(
          'Total Seasons: ' + tvShow.numberOfSeasons.toString(),
        ),
        const SizedBox(height: 16),
        Text(
          'Overview',
          style: kHeading6,
        ),
        Text(
          tvShow.overview.isNotEmpty ? tvShow.overview : "-",
        ),
        const SizedBox(height: 16),
        Text(
          'Recommendations',
          style: kHeading6,
        ),
        BlocBuilder<TVShowRecommendationsBloc, TVShowRecommendationsState>(
          key: const Key('recommendation_tv_show'),
          builder: (context, state) {
            if (state is TVShowRecommendationsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TVShowRecommendationsHasData) {
              final tvShowRecommendations = state.result;

              return Container(
                margin: const EdgeInsets.only(top: 8.0),
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final tvShowRecoms = tvShowRecommendations[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            TVShowDetailPage.routeName,
                            arguments: tvShowRecoms.id,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: '$baseImageUrl${tvShowRecoms.posterPath}',
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
                  itemCount: tvShowRecommendations.length,
                ),
              );
            } else {
              return const Text('No recommendations found');
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Seasons',
          style: kHeading6,
        ),
        tvShow.seasons.isNotEmpty
            ? Container(
                height: 150,
                margin: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    final season = tvShow.seasons[index];

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            season.posterPath == null
                                ? Container(
                                    width: 96.0,
                                    decoration: const BoxDecoration(
                                      color: kGrey,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'No Image',
                                        style: TextStyle(color: kRichBlack),
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        '$baseImageUrl${season.posterPath}',
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                            Positioned.fill(
                              child: Container(
                                color: kRichBlack.withOpacity(0.65),
                              ),
                            ),
                            Positioned(
                              left: 8.0,
                              top: 4.0,
                              child: Text(
                                (index + 1).toString(),
                                style: kHeading5.copyWith(fontSize: 26.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: tvShow.seasons.length,
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
