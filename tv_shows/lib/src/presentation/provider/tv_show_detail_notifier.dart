import 'package:core_app/core_app.dart'
    show
        GetTVShowDetail,
        GetTVShowRecommendations,
        GetWatchListStatusTVShow,
        RemoveWatchlistTVShow,
        RequestState,
        SaveWatchlistTVShow,
        TVShow,
        TVShowDetail;
import 'package:flutter/foundation.dart';

class TVShowDetailNotifier extends ChangeNotifier {
  TVShowDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVShowRecommendations,
    required this.getWatchListStatusTVShow,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  final GetTVShowDetail getTVShowDetail;
  final GetTVShowRecommendations getTVShowRecommendations;
  final GetWatchListStatusTVShow getWatchListStatusTVShow;
  final SaveWatchlistTVShow saveWatchlist;
  final RemoveWatchlistTVShow removeWatchlist;

  late TVShowDetail _tvShowDetail;
  TVShowDetail get tvShowDetail => _tvShowDetail;

  RequestState _tvShowState = RequestState.empty;
  RequestState get tvShowState => _tvShowState;

  List<TVShow> _tvShowRecommendations = [];
  List<TVShow> get tvShowRecommendations => _tvShowRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTVShowDetail(int id) async {
    _tvShowState = RequestState.loading;
    notifyListeners();

    final detailResult = await getTVShowDetail.execute(id);
    final recommendationResult = await getTVShowRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _tvShowState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShow) {
        _recommendationState = RequestState.loading;
        _tvShowDetail = tvShow;
        notifyListeners();

        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvShows) {
            _recommendationState = RequestState.loaded;
            _tvShowRecommendations = tvShows;
          },
        );
        _tvShowState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TVShowDetail tvShow) async {
    final result = await saveWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> removeFromWatchlist(TVShowDetail tvShow) async {
    final result = await removeWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTVShow.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
