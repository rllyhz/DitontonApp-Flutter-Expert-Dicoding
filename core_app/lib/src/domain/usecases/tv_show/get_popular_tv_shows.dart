import 'package:dartz/dartz.dart';
import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/tv_show.dart';
import 'package:core_app/src/domain/repositories/tv_show_repository.dart';

class GetPopularTVShows {
  final TVShowRepository repository;

  GetPopularTVShows(this.repository);

  Future<Either<Failure, List<TVShow>>> execute() {
    return repository.getPopularTVShows();
  }
}
