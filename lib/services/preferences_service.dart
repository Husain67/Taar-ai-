import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _apiProviderKey = 'api_provider';
  static const String _apiKey = 'api_key';
  static const String _modelKey = 'model';

  Future<void> saveSettings(String provider, String apiKey, String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiProviderKey, provider);
    await prefs.setString(_apiKey, apiKey);
    await prefs.setString(_modelKey, model);
  }

  Future<Map<String, String>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = prefs.getString(_apiProviderKey) ?? 'OpenRouter';
    final apiKey = prefs.getString(_apiKey) ?? '';
    final model = prefs.getString(_modelKey) ?? 'z-ai/glm-4.6';
    return {
      'provider': provider,
      'apiKey': apiKey,
      'model': model,
    };
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKey);
  }

  Future<String?> getApiProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiProviderKey);
  }

  Future<String?> getModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_modelKey);
  }
}
