import 'package:dartz/dartz.dart';
import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/movie_detail.dart';
import 'package:core_app/src/domain/repositories/movie_repository.dart';

class RemoveWatchlistMovie {
  final MovieRepository repository;

  RemoveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
