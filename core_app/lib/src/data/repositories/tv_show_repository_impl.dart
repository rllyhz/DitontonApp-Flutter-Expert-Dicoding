import 'dart:io';

import 'package:core_app/src/common/exception.dart';
import 'package:core_app/src/common/failure.dart';
import 'package:core_app/src/data/datasources/tv_show_local_data_source.dart';
import 'package:core_app/src/data/datasources/tv_show_remote_data_source.dart';
import 'package:core_app/src/data/models/tv_show_table.dart';
import 'package:core_app/src/domain/entities/tv_show.dart';
import 'package:core_app/src/domain/entities/tv_show_detail.dart';
import 'package:core_app/src/domain/repositories/tv_show_repository.dart';
import 'package:dartz/dartz.dart';

class TVShowRepositoryImpl implements TVShowRepository {
  TVShowRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TVShowRemoteDataSource remoteDataSource;
  final TVShowLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<TVShow>>> getNowPlayingTVShows() async {
    try {
      final result = await remoteDataSource.getNowPlayingTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> getPopularTVShows() async {
    try {
      final result = await remoteDataSource.getPopularTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TVShowDetail>> getTVShowDetail(int id) async {
    try {
      final result = await remoteDataSource.getTVShowDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> getTVShowRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTVShowRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> getTopRatedTVShows() async {
    try {
      final result = await remoteDataSource.getTopRatedTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> searchTVShows(String query) async {
    try {
      final result = await remoteDataSource.searchTVShows(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated not valid\n${e.message}'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TVShow>>> getWatchlistTVShows() async {
    final result = await localDataSource.getWatchlistTVShows();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTVShowById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TVShowDetail tvShow) async {
    try {
      final result =
          await localDataSource.removeWatchlist(TVShowTable.fromEntity(tvShow));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TVShowDetail tvShow) async {
    try {
      final result =
          await localDataSource.insertWatchlist(TVShowTable.fromEntity(tvShow));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }
}
