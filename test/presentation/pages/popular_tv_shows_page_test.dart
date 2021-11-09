import 'package:core_app/core_app.dart' show RequestState;
import 'package:ditonton/presentation/pages/popular_tv_shows_page.dart';
import 'package:ditonton/presentation/provider/popular_tv_shows_notifier.dart';
import 'package:ditonton/presentation/widgets/content_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_shows_page_test.mocks.dart';

@GenerateMocks([PopularTVShowsNotifier])
void main() {
  late MockPopularTVShowsNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockPopularTVShowsNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularTVShowsNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display AppBar when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tvShows).thenReturn(testTVShowList);

    await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Popular TVShows'), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tvShows).thenReturn(testTVShowList);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(ContentCardList), findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

    expect(textFinder, findsOneWidget);
  });
}
