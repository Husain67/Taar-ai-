import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_universe_chat/services/preferences_service.dart';

class ApiService {
  final PreferencesService _preferencesService = PreferencesService();

  Future<Stream<String>> getChatCompletion(String userInput) async {
    final settings = await _preferencesService.loadSettings();
    final provider = settings['provider'];
    final apiKey = settings['apiKey'];
    final model = settings['model'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API Key not found.');
    }

    if (provider == 'OpenRouter') {
      return _getOpenRouterCompletion(userInput, apiKey, model!);
    } else if (provider == 'Groq') {
      return _getGroqCompletion(userInput, apiKey, model!);
    } else if (provider == 'Kilo Code' || provider == 'HuggingFace' || provider == 'Gemini') {
      throw Exception('$provider is not yet supported.');
    } else {
      throw Exception('Unsupported API Provider.');
    }
  }

  Stream<String> _getOpenRouterCompletion(String userInput, String apiKey, String model) async* {
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'X-Title': 'AI Universe Chat',
    };
    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'user', 'content': userInput}
      ],
      'stream': true,
    });

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = body;

    final response = await http.Client().send(request);

    if (response.statusCode == 200) {
      final stream = response.stream.transform(utf8.decoder);
      await for (var chunk in stream) {
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') {
              return;
            }
            final json = jsonDecode(data);
            if (json['choices'] != null && json['choices'].isNotEmpty) {
              final delta = json['choices'][0]['delta'];
              if (delta != null && delta['content'] != null) {
                yield delta['content'];
              }
            }
          }
        }
      }
    } else {
      throw Exception('Failed to get completion from OpenRouter: ${response.statusCode}');
    }
  }

  Stream<String> _getGroqCompletion(String userInput, String apiKey, String model) async* {
    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'user', 'content': userInput}
      ],
      'stream': true,
    });

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = body;

    final response = await http.Client().send(request);

    if (response.statusCode == 200) {
      final stream = response.stream.transform(utf8.decoder);
      await for (var chunk in stream) {
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') {
              return;
            }
            final json = jsonDecode(data);
            if (json['choices'] != null && json['choices'].isNotEmpty) {
              final delta = json['choices'][0]['delta'];
              if (delta != null && delta['content'] != null) {
                yield delta['content'];
              }
            }
          }
        }
      }
    } else {
      throw Exception('Failed to get completion from Groq: ${response.statusCode}');
    }
  }
}
