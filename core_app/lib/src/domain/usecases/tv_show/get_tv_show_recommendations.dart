import 'package:dartz/dartz.dart';
import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/tv_show.dart';
import 'package:core_app/src/domain/repositories/tv_show_repository.dart';

class GetTVShowRecommendations {
  final TVShowRepository repository;

  GetTVShowRecommendations(this.repository);

  Future<Either<Failure, List<TVShow>>> execute(id) {
    return repository.getTVShowRecommendations(id);
  }
}
