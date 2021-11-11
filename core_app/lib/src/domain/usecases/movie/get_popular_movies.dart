import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/movie.dart';
import 'package:core_app/src/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
