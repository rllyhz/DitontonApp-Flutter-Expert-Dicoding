import 'package:core_app/core_app.dart'
    show GetWatchlistTVShows, RequestState, TVShow;
import 'package:flutter/foundation.dart';

class WatchlistTVShowNotifier extends ChangeNotifier {
  var _watchlistTVShows = <TVShow>[];
  List<TVShow> get watchlistTVShows => _watchlistTVShows;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTVShowNotifier({required this.getWatchlistTVShows});

  final GetWatchlistTVShows getWatchlistTVShows;

  Future<void> fetchWatchlistTVShows() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlistTVShows.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _watchlistState = RequestState.loaded;
        _watchlistTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }
}
