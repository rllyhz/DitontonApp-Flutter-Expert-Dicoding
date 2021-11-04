import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/ssl_pinning/shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SSL Pinning tests', () {
    test('should get response 200 when connection succeeded', () async {
      final _myClient = await Shared.createLEClient(isTestMode: true);
      final response = await _myClient
          .get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));

      expect(response.statusCode, 200);
      _myClient.close();
    });
  });
}
