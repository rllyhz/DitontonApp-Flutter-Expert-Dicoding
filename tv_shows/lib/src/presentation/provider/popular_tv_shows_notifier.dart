import 'package:core_app/core_app.dart'
    show GetPopularTVShows, RequestState, TVShow;
import 'package:flutter/foundation.dart';

class PopularTVShowsNotifier extends ChangeNotifier {
  final GetPopularTVShows getPopularTVShows;

  PopularTVShowsNotifier(this.getPopularTVShows);

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TVShow> _tvShows = [];
  List<TVShow> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTVShows() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();

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
