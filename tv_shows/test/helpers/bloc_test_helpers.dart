import 'package:core_app/core_app.dart'
    show
        GetNowPlayingTVShows,
        GetPopularTVShows,
        GetTVShowDetail,
        GetTVShowRecommendations,
        GetTopRatedTVShows,
        GetWatchListStatusTVShow,
        GetWatchlistTVShows,
        RemoveWatchlistTVShow,
        SaveWatchlistTVShow;
import 'package:mockito/annotations.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVShowRecommendations,
  GetNowPlayingTVShows,
  GetPopularTVShows,
  GetTopRatedTVShows,
  GetWatchListStatusTVShow,
  GetWatchlistTVShows,
  SaveWatchlistTVShow,
  RemoveWatchlistTVShow,
])
void main() {}
