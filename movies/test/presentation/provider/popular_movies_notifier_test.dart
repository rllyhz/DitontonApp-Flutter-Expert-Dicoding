import 'package:core_app/core_app.dart'
    show GetPopularMovies, RequestState, ServerFailure;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/src/presentation/provider/popular_movies_notifier.dart';

import '../../../../test/dummy_data/dummy_objects.dart';
import 'popular_movies_notifier_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularMovies = MockGetPopularMovies();
    notifier = PopularMoviesNotifier(mockGetPopularMovies)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(testMovieList));
    // act
    notifier.fetchPopularMovies();
    // assert
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(testMovieList));
    // act
    await notifier.fetchPopularMovies();
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.movies, testMovieList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularMovies();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
