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

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTVShows = <TVShow>[];
  List<TVShow> get popularTVShows => _popularTVShows;

  RequestState _popularTVShowsState = RequestState.Empty;
  RequestState get popularTVShowsState => _popularTVShowsState;

  var _topRatedTVShows = <TVShow>[];
  List<TVShow> get topRatedTVShows => _topRatedTVShows;

  RequestState _topRatedTVShowsState = RequestState.Empty;
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
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTVShows.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVShows() async {
    _popularTVShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
    result.fold(
      (failure) {
        _popularTVShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _popularTVShowsState = RequestState.Loaded;
        _popularTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVShows() async {
    _topRatedTVShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();
    result.fold(
      (failure) {
        _topRatedTVShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _topRatedTVShowsState = RequestState.Loaded;
        _topRatedTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
