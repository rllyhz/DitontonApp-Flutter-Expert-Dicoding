import 'package:core_app/core_app.dart'
    show
        DatabaseHelper,
        MovieLocalDataSource,
        MovieRepository,
        TVShowLocalDataSource,
        TVShowRepository;
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieLocalDataSource,
  TVShowRepository,
  TVShowLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
