import 'package:dartz/dartz.dart';
import 'package:core_app/src/domain/entities/movie.dart';
import 'package:core_app/src/domain/repositories/movie_repository.dart';
import 'package:core_app/src/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
