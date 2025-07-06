import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Ensure async is awaited correctly
  await fetchRecipeDetails();
}

Future<void> fetchRecipeDetails() async {
  final url = Uri.parse(
    'https://us-central1-chef-intelligence-app.cloudfunctions.net/api//ai/details',
  );

  final res = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': 'C9Bq28UUdZY0WBFiO6yzosil2Hs1',
      'ingredients': 'chicken',
      'recipe_index': '0',
    }),
  );

  print('Status: ${res.statusCode}');
  print('Body: ${res.body}');
}
