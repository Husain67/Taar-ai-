import 'package:flutter/material.dart';
import 'package:ai_universe_chat/services/preferences_service.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
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
      SnackBar(content: Text('settings_saved'.tr())),
    );
  }

  void _resetSettings() {
    _preferencesService.saveSettings('OpenRouter', '', 'z-ai/glm-4.6');
    _loadSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('settings_reset'.tr())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('settings'.tr()),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDropdown('api_provider'.tr(), _selectedProvider, ['OpenRouter', 'Kilo Code', 'Groq', 'HuggingFace', 'Gemini'], (value) {
            setState(() {
              _selectedProvider = value!;
            });
          }),
          const SizedBox(height: 20),
          _buildTextField('api_key'.tr(), _apiKeyController, isPassword: true),
          const SizedBox(height: 20),
          _buildDropdown('model'.tr(), _selectedModel, ['z-ai/glm-4.6', 'openai/gpt-oss-20b', 'alibaba/tongyi-deepresearch-30b-a3b:free'], (value) {
            setState(() {
              _selectedModel = value!;
            });
          }),
          const SizedBox(height: 40),
          _buildButton('save_key'.tr(), _saveSettings),
          const SizedBox(height: 10),
          _buildButton('reset'.tr(), _resetSettings, isOutlined: true),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: Theme.of(context).cardColor,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: const Icon(Icons.copy),
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
              child: Text(text),
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
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
    );
  }
}
