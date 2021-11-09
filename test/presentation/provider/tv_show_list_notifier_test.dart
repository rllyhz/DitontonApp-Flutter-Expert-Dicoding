import 'package:dartz/dartz.dart';
import 'package:core_app/core_app.dart'
    show
        GetNowPlayingTVShows,
        GetPopularTVShows,
        GetTopRatedTVShows,
        RequestState,
        ServerFailure;
import 'package:ditonton/presentation/provider/tv_show_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVShows, GetPopularTVShows, GetTopRatedTVShows])
void main() {
  late TVShowListNotifier provider;
  late MockGetNowPlayingTVShows mockGetNowPlayingTVShows;
  late MockGetPopularTVShows mockGetPopularTVShows;
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVShows = MockGetNowPlayingTVShows();
    mockGetPopularTVShows = MockGetPopularTVShows();
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();

    provider = TVShowListNotifier(
      getNowPlayingTVShows: mockGetNowPlayingTVShows,
      getPopularTVShows: mockGetPopularTVShows,
      getTopRatedTVShows: mockGetTopRatedTVShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('now playing tv shows', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      provider.fetchNowPlayingTVShows();
      // assert
      verify(mockGetNowPlayingTVShows.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      provider.fetchNowPlayingTVShows();
      // assert
      expect(provider.nowPlayingState, RequestState.loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await provider.fetchNowPlayingTVShows();
      // assert
      expect(provider.nowPlayingState, RequestState.loaded);
      expect(provider.nowPlayingTVShows, testTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTVShows();
      // assert
      expect(provider.nowPlayingState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVShowsState, RequestState.loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVShowsState, RequestState.loaded);
      expect(provider.popularTVShows, testTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVShowsState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedTVShowsState, RequestState.loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedTVShowsState, RequestState.loaded);
      expect(provider.topRatedTVShows, testTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedTVShowsState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
