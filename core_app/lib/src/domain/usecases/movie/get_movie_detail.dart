import 'package:dartz/dartz.dart';
import 'package:core_app/src/domain/entities/movie_detail.dart';
import 'package:core_app/src/domain/repositories/movie_repository.dart';
import 'package:core_app/src/common/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
