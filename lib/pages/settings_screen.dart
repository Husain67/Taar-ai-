import 'package:flutter/material.dart';
import 'package:ai_universe_chat/services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  String _selectedProvider = 'OpenRouter';
  final TextEditingController _apiKeyController = TextEditingController();
  String _selectedModel = 'z-ai/glm-4.6';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final settings = await _preferencesService.loadSettings();
    setState(() {
      _selectedProvider = settings['provider']!;
      _apiKeyController.text = settings['apiKey']!;
      _selectedModel = settings['model']!;
    });
  }

  void _saveSettings() {
    _preferencesService.saveSettings(
      _selectedProvider,
      _apiKeyController.text,
      _selectedModel,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved!')),
    );
  }

  void _resetSettings() {
    _preferencesService.saveSettings('OpenRouter', '', 'z-ai/glm-4.6');
    _loadSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Kilo Code Documentation',
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDropdown('API Provider', _selectedProvider, ['OpenRouter', 'Kilo Code', 'Groq', 'HuggingFace', 'Gemini'], (value) {
            setState(() {
              _selectedProvider = value!;
            });
          }),
          const SizedBox(height: 20),
          _buildTextField('API Key', _apiKeyController, isPassword: true),
          const SizedBox(height: 20),
          _buildDropdown('Model', _selectedModel, ['z-ai/glm-4.6', 'openai/gpt-oss-20b', 'alibaba/tongyi-deepresearch-30b-a3b:free'], (value) {
            setState(() {
              _selectedModel = value!;
            });
          }),
          const SizedBox(height: 40),
          _buildButton('Save Key', _saveSettings),
          const SizedBox(height: 10),
          _buildButton('Reset', _resetSettings, isOutlined: true),
          const SizedBox(height: 10),
          _buildButton('Log Out', () {}, isOutlined: true),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: const Color(0xFF1E1E1E),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white70),
                    onPressed: () {},
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, {bool isOutlined = false}) {
    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.white54),
              ),
              child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
    );
  }
}
