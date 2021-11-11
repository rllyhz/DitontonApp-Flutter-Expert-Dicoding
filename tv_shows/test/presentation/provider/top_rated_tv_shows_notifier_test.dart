import 'package:dartz/dartz.dart';
import 'package:core_app/core_app.dart'
    show GetTopRatedTVShows, RequestState, ServerFailure;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/src/presentation/provider/top_rated_tv_shows_notifier.dart';

import '../../dummy_objects.dart';
import 'top_rated_tv_shows_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTVShows])
void main() {
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late TopRatedTVShowsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    notifier =
        TopRatedTVShowsNotifier(getTopRatedTVShows: mockGetTopRatedTVShows)
          ..addListener(() {
            listenerCallCount++;
          });
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedTVShows.execute())
        .thenAnswer((_) async => Right(testTVShowList));
    // act
    notifier.fetchTopRatedTVShows();
    // assert
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv shows data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetTopRatedTVShows.execute())
        .thenAnswer((_) async => Right(testTVShowList));
    // act
    await notifier.fetchTopRatedTVShows();
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.tvShows, testTVShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTVShows.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTVShows();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
