import 'package:core_app/core_app.dart'
    show
        GetNowPlayingTVShows,
        GetPopularTVShows,
        GetTopRatedTVShows,
        RequestState,
        TVShow;
import 'package:flutter/foundation.dart';

class TVShowListNotifier extends ChangeNotifier {
  var _nowPlayingTVShows = <TVShow>[];
  List<TVShow> get nowPlayingTVShows => _nowPlayingTVShows;

  RequestState _nowPlayingState = RequestState.empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTVShows = <TVShow>[];
  List<TVShow> get popularTVShows => _popularTVShows;

  RequestState _popularTVShowsState = RequestState.empty;
  RequestState get popularTVShowsState => _popularTVShowsState;

  var _topRatedTVShows = <TVShow>[];
  List<TVShow> get topRatedTVShows => _topRatedTVShows;

  RequestState _topRatedTVShowsState = RequestState.empty;
  RequestState get topRatedTVShowsState => _topRatedTVShowsState;

  String _message = '';
  String get message => _message;

  TVShowListNotifier({
    required this.getNowPlayingTVShows,
    required this.getPopularTVShows,
    required this.getTopRatedTVShows,
  });

  final GetNowPlayingTVShows getNowPlayingTVShows;
  final GetPopularTVShows getPopularTVShows;
  final GetTopRatedTVShows getTopRatedTVShows;

  Future<void> fetchNowPlayingTVShows() async {
    _nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingTVShows.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _nowPlayingState = RequestState.loaded;
        _nowPlayingTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVShows() async {
    _popularTVShowsState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
    result.fold(
      (failure) {
        _popularTVShowsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _popularTVShowsState = RequestState.loaded;
        _popularTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVShows() async {
    _topRatedTVShowsState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();
    result.fold(
      (failure) {
        _topRatedTVShowsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _topRatedTVShowsState = RequestState.loaded;
        _topRatedTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
