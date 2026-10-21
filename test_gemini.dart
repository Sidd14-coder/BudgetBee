import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String apiKey = "AIzaSyA4bk6ldx1e1e0-NMfykDun6L8c4c6t58E";
  final url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey";
  
  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [{"text": "Hello"}]
        }
      ]
    })
  );
  
  print("STATUS: ${response.statusCode}");
  if (response.statusCode == 200) {
    print("BODY: ${response.body.substring(0, 100)}...");
  } else {
    print("ERROR: ${response.body}");
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  String apiKey = "AIzaSyDNq98N83RwBI2MaO1dbUVpDRhiqGox2_o";
  String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";
  List<Map<String, dynamic>> contents = [
    {
      "role": "user",
      "parts": [{"text": "System Instructions:\nYou are a helpful bot.\n\nHere is the user's question:\nHello"}]
    }
  ];
  final response = await http.post(
    Uri.parse(endpoint),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"contents": contents})
  );
  print(response.statusCode);
  print(response.body);
}
