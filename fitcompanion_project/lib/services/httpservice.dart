import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitcompanion_project/model/Exercises.dart';

class ExerciseService {
  static const String apiUrl = 'https://api.api-ninjas.com/v1/exercises';
  static const String apiKey = '5X6vHbKnTxG483Rg0Boa+w==TbfGlsOlWafGzPVv';

  Future<List<Exercises>> fetchExercises({String muscle}) async {
    try {
      Uri uri = Uri.parse(apiUrl);
      if (muscle != null) {
        uri = Uri.parse('$apiUrl?muscle=$muscle');
      }
      
      final response = await http.get(
        uri,
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => Exercises.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      throw Exception('Failed to fetch exercises: $e');
    }
  }
}

class OpenAIChatbot {
  final String apiKey = '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';

  Future<String> sendMessage(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // Adjust the model as needed
          'messages': [
            {'role': 'user', 'content': message},
          ],
        }));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final chatResponse = responseBody['choices'][0]['message']['content'];
      return chatResponse;
    } else {
      throw Exception('Failed to load response from OpenAI');
    }
  }
}