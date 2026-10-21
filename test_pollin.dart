import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final url = 'https://text.pollinations.ai/';

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": "What is 2+2?"}
        ]
      }),
    );

    print(response.statusCode);
    print(response.body);
  } catch (e) {
    print(e);
  }
}
