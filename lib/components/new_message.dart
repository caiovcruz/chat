import 'package:flutter/material.dart';

import '../core/services/auth/auth_service.dart';
import '../core/services/chat/chat_service.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final currentUser = AuthService().currentUser;

    if (currentUser != null) {
      await ChatService().save(_message.trim(), currentUser);
      _messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  bool get messageNotEmpty => _message.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
                top: 10,
                right: messageNotEmpty ? 0 : 10,
                bottom: 10,
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Send a message...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (message) => setState(() => _message = message),
                onSubmitted: (_) {
                  if (messageNotEmpty) {
                    _sendMessage();
                  }
                },
              ),
            ),
          ),
          if (messageNotEmpty)
            TextButton(
              style: TextButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
              ),
              onPressed: _sendMessage,
              child: const Icon(Icons.send),
            ),
        ],
      ),
    );
  }
}
