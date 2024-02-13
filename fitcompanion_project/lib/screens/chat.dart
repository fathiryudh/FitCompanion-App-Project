import 'package:flutter/material.dart';
import 'package:fitcompanion_project/services/httpservice.dart';

class FitCompanionChat extends StatefulWidget {
  @override
  State<FitCompanionChat> createState() => _FitCompanionChatState();
}

class _FitCompanionChatState extends State<FitCompanionChat> {
  final OpenAIChatbot chatbot = OpenAIChatbot();
  final TextEditingController _controller = TextEditingController();
  List<String> _messages = [];
  bool _isTyping = false;

  void _sendMessage() async {
    final text = _controller.text;
    setState(() {
      _messages.add('You: $text');
      _isTyping = true;
    });
    _controller.clear();

    final response = await chatbot.sendMessage(text);
    setState(() {
      _messages.add('FitCompanion: $response');
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text('FitCompanion is typing...'),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Align(
                      alignment: _messages[index].startsWith('You')
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: _messages[index].startsWith('You')
                              ? Colors.blueAccent.withOpacity(0.8)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          _messages[index],
                          style: TextStyle(
                            color: _messages[index].startsWith('You')
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask your companion...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
