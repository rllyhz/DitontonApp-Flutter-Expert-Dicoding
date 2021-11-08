import 'package:core_app/core_app.dart'
    show GetWatchlistTVShows, RequestState, TVShow;
import 'package:flutter/foundation.dart';

class WatchlistTVShowNotifier extends ChangeNotifier {
  var _watchlistTVShows = <TVShow>[];
  List<TVShow> get watchlistTVShows => _watchlistTVShows;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTVShowNotifier({required this.getWatchlistTVShows});

  final GetWatchlistTVShows getWatchlistTVShows;

  Future<void> fetchWatchlistTVShows() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTVShows.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
