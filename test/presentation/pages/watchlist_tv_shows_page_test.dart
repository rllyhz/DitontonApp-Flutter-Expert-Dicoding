import 'package:core_app/core_app.dart'
    show RequestState, TVShow, watchlistTVShowEmptyMessage;
import 'package:ditonton/presentation/pages/watchlist_tv_shows_page.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_show_notifier.dart';
import 'package:ditonton/presentation/widgets/content_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_shows_page_test.mocks.dart';

@GenerateMocks([WatchlistTVShowNotifier])
void main() {
  late MockWatchlistTVShowNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistTVShowNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistTVShowNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('watchlist tv shows', () {
    testWidgets('watchlist tv shows should display',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
      when(mockNotifier.watchlistTVShows).thenReturn(testTVShowList);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.byType(ContentCardList), findsWidgets);
    });

    testWidgets('message for feedback should display when data is empty',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
      when(mockNotifier.watchlistTVShows).thenReturn(<TVShow>[]);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.text(watchlistTVShowEmptyMessage), findsOneWidget);
    });

    testWidgets('loading indicator should display when getting data',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.loading);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
