import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/movie_detail.dart';
import 'package:core_app/src/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class SaveWatchlistMovie {
  final MovieRepository repository;

  SaveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
