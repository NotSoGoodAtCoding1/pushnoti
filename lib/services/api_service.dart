import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'https://example.com'; // сервер здесь

  static Future<void> registerDevice(String token) async {
    final url = Uri.parse('$_baseUrl/api/device/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      print('Токен успешно отправлен на сервер');
    } else {
      print('Ошибка при отправке токена: ${response.statusCode}');
    }
  }
}
