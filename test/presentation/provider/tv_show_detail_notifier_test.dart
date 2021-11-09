import 'package:dartz/dartz.dart';
import 'package:core_app/core_app.dart'
    show
        DatabaseFailure,
        GetTVShowDetail,
        GetTVShowRecommendations,
        GetWatchListStatusTVShow,
        RemoveWatchlistTVShow,
        RequestState,
        SaveWatchlistTVShow,
        ServerFailure;
import 'package:ditonton/presentation/provider/tv_show_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVShowRecommendations,
  GetWatchListStatusTVShow,
  SaveWatchlistTVShow,
  RemoveWatchlistTVShow,
])
void main() {
  late TVShowDetailNotifier provider;
  late MockGetTVShowDetail mockGetTVShowDetail;
  late MockGetTVShowRecommendations mockGetTVShowRecommendations;
  late MockGetWatchListStatusTVShow mockGetWatchlistStatus;
  late MockSaveWatchlistTVShow mockSaveWatchlist;
  late MockRemoveWatchlistTVShow mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVShowDetail = MockGetTVShowDetail();
    mockGetTVShowRecommendations = MockGetTVShowRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTVShow();
    mockSaveWatchlist = MockSaveWatchlistTVShow();
    mockRemoveWatchlist = MockRemoveWatchlistTVShow();
    provider = TVShowDetailNotifier(
      getTVShowDetail: mockGetTVShowDetail,
      getTVShowRecommendations: mockGetTVShowRecommendations,
      getWatchListStatusTVShow: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetTVShowDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVShowDetail));
    when(mockGetTVShowRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTVShowList));
  }

  group('Get TVShow Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      verify(mockGetTVShowDetail.execute(tId));
      verify(mockGetTVShowRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.tvShowState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv show when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.tvShowState, RequestState.loaded);
      expect(provider.tvShowDetail, testTVShowDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.tvShowState, RequestState.loaded);
      expect(provider.tvShowRecommendations, testTVShowList);
    });
  });

  group('Get TVShow Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      verify(mockGetTVShowRecommendations.execute(tId));
      expect(provider.tvShowRecommendations, testTVShowList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.loaded);
      expect(provider.tvShowRecommendations, testTVShowList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVShowDetail));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTVShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVShowDetail);
      // assert
      verify(mockSaveWatchlist.execute(testTVShowDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTVShowDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTVShowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTVShowDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testTVShowDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTVShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVShowDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testTVShowDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTVShowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTVShowDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await provider.fetchTVShowDetail(tId);
      // assert
      expect(provider.tvShowState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
