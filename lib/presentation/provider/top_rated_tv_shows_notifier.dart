import 'package:core_app/core_app.dart'
    show GetTopRatedTVShows, RequestState, TVShow;
import 'package:flutter/foundation.dart';

class TopRatedTVShowsNotifier extends ChangeNotifier {
  final GetTopRatedTVShows getTopRatedTVShows;

  TopRatedTVShowsNotifier({required this.getTopRatedTVShows});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TVShow> _tvShows = [];
  List<TVShow> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTVShows() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvShowsData) {
        _tvShows = tvShowsData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
