import 'package:core_app/src/data/datasources/db/database_helper.dart';
import 'package:core_app/src/data/datasources/movie_local_data_source.dart';
import 'package:core_app/src/data/datasources/movie_remote_data_source.dart';
import 'package:core_app/src/data/datasources/tv_show_local_data_source.dart';
import 'package:core_app/src/data/datasources/tv_show_remote_data_source.dart';
import 'package:core_app/src/domain/repositories/movie_repository.dart';
import 'package:core_app/src/domain/repositories/tv_show_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  TVShowRepository,
  MovieRemoteDataSource,
  TVShowRemoteDataSource,
  MovieLocalDataSource,
  TVShowLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
