import 'package:http/http.dart' as http;

class NetworkClient {
  final http.Client client;

  NetworkClient(this.client);

  Future<http.Response> get(String url) async {
    return await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
