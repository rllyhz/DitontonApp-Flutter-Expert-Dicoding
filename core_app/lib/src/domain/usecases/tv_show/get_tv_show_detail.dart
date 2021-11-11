import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/domain/entities/tv_show_detail.dart';
import 'package:core_app/src/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';

class GetTVShowDetail {
  final TVShowRepository repository;

  GetTVShowDetail(this.repository);

  Future<Either<Failure, TVShowDetail>> execute(int id) {
    return repository.getTVShowDetail(id);
  }
}
