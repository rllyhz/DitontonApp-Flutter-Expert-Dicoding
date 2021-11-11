import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_app/core_app.dart'
    show
        RequestState,
        ScrollableSheetContainer,
        TVShowDetail,
        baseImageUrl,
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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/src/presentation/provider/tv_show_detail_notifier.dart';

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
      Provider.of<TVShowDetailNotifier>(context, listen: false)
          .fetchTVShowDetail(widget.id);
      Provider.of<TVShowDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<TVShowDetailNotifier>(
          builder: (ctx, provider, child) {
            if (provider.tvShowState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.tvShowState == RequestState.loaded) {
              final tvShow = provider.tvShowDetail;
              return DetailContent(tvShow, provider);
            } else {
              return Center(child: Text(provider.message));
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVShowDetail tvShow;
  final TVShowDetailNotifier provider;

  DetailContent(this.tvShow, this.provider);

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
            if (!provider.isAddedToWatchlist) {
              await provider.addWatchlist(tvShow);
            } else {
              await provider.removeFromWatchlist(tvShow);
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
        provider.tvShowRecommendations.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 8.0),
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final tvShowRecoms = provider.tvShowRecommendations[index];
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
                  itemCount: provider.tvShowRecommendations.length,
                ),
              )
            : const Text('No recommendations found'),
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
