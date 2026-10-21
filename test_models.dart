import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String apiKey = "AIzaSyA4bk6ldx1e1e0-NMfykDun6L8c4c6t58E";
  final url = "https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey";
  
  final response = await http.get(Uri.parse(url));
  print("STATUS: ${response.statusCode}");
  if (response.statusCode == 200) {
    try {
      final data = jsonDecode(response.body);
      for (var model in data['models']) {
        print(model['name']);
      }
    } catch (e) { print(response.body); }
  } else {
    print("ERROR: ${response.body}");
  }
}
