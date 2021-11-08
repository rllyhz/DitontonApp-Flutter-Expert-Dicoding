import 'package:dartz/dartz.dart';
import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/tv_show_detail.dart';
import 'package:core_app/src/domain/repositories/tv_show_repository.dart';

class RemoveWatchlistTVShow {
  final TVShowRepository repository;

  RemoveWatchlistTVShow(this.repository);

  Future<Either<Failure, String>> execute(TVShowDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
