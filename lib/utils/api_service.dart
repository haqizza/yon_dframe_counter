import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIService {
  static Future<http.Response> sendImage({var body}) async {
    var response = await http.post(
      Uri.parse('${dotenv.env['MODEL_URL']}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print(response);
    return response;
  }
}