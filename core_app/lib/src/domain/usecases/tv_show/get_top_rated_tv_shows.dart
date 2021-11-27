import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/tv_show.dart';
import 'package:core_app/src/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';

class GetTopRatedTVShows {
  final TVShowRepository repository;

  GetTopRatedTVShows(this.repository);

  Future<Either<Failure, List<TVShow>>> execute() {
    return repository.getTopRatedTVShows();
  }
}
