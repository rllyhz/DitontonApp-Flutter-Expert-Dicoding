import 'package:dartz/dartz.dart';
import 'package:core_app/src/domain/entities/movie.dart';
import 'package:core_app/src/domain/repositories/movie_repository.dart';
import 'package:core_app/src/common/failure.dart';

class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
