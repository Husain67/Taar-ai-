import 'package:ai_universe_chat/pages/settings_screen.dart';
import 'package:ai_universe_chat/widgets/chat_history_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:ai_universe_chat/models/chat_message.dart';
import 'package:ai_universe_chat/services/api_service.dart';
import 'package:ai_universe_chat/widgets/app_drawer.dart';
import 'package:ai_universe_chat/widgets/chat_bubble.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final List<ChatMessage> _messages = [
    ChatMessage(
      role: "assistant",
      content: "Hello! How can I assist you today?"
    ),
  ];
  bool _isLoading = false;

  void _sendMessage() async {
    final userInput = _controller.text;
    if (userInput.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: 'user', content: userInput));
      _isLoading = true;
      _messages.add(ChatMessage(role: 'assistant', content: ''));
    });

    _controller.clear();

    try {
      final stream = await _apiService.getChatCompletion(userInput);
      stream.listen((contentChunk) {
        setState(() {
          _messages.last.content += contentChunk;
        });
      }, onDone: () {
        setState(() {
          _isLoading = false;
        });
      }, onError: (error) {
        setState(() {
          _messages.last.content = 'Error: ${error.toString()}';
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _messages.last.content = 'Error: Failed to connect to the service.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('chatbot_title'.tr()),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatHistorySearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message.content,
                  isUser: message.role == 'user',
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(
                hintText: 'type_message'.tr(),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
